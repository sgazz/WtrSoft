import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguagePicker = false
    @State private var showingJSONData = false
    
    var body: some View {
        ZStack {
            // Pozadinski gradijent
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Search bar i dugmad
                    HStack {
                        SearchBar(cityName: $viewModel.cityName) {
                            withAnimation {
                                viewModel.fetchWeather(for: viewModel.cityName)
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Button(action: { showingLanguagePicker = true }) {
                                Image(systemName: "globe")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { showingJSONData = true }) {
                                Image(systemName: "curlybraces")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let weather = viewModel.weather {
                        WeatherInfoView(weather: weather)
                            .transition(.scale.combined(with: .opacity))
                        
                        if let forecast = viewModel.forecast {
                            ForecastView(forecast: forecast)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    } else {
                        LoadingView()
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            withAnimation {
                viewModel.fetchWeather(for: viewModel.cityName)
            }
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView()
        }
        .sheet(isPresented: $showingJSONData) {
            JSONDataView(jsonData: viewModel.jsonData)
        }
    }
}

// MARK: - Subviews
private struct SearchBar: View {
    @Binding var cityName: String
    let onSearch: () -> Void
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        HStack {
            TextField(localizationManager.localizedString(.enterCity), text: $cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
            
            Button(action: onSearch) {
                Text(localizationManager.localizedString(.show))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }
    }
}

private struct WeatherInfoView: View {
    let weather: WeatherResponse
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var viewModel = WeatherViewModel()
    @State private var currentTime = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("\(weather.name), \(weather.sys.country)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text("\(localizationManager.localizedString(.currentTime)): \(currentTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let icon = weather.weather.first?.icon {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            
            // Temperature section
            VStack(spacing: 15) {
                Text("\(Int(weather.main.temp))℃")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 25) {
                    TemperatureInfo(title: localizationManager.localizedString(.minTemp),
                                  value: "\(Int(weather.main.temp_min))℃")
                    TemperatureInfo(title: localizationManager.localizedString(.maxTemp),
                                  value: "\(Int(weather.main.temp_max))℃")
                    TemperatureInfo(title: localizationManager.localizedString(.feelsLike),
                                  value: "\(Int(weather.main.feels_like))℃")
                }
            }
            
            // Weather details
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                WeatherDataRow(title: localizationManager.localizedString(.description),
                             value: weather.weather.first?.description.capitalized ?? "")
                WeatherDataRow(title: localizationManager.localizedString(.humidity),
                             value: "\(weather.main.humidity)%")
                WeatherDataRow(title: localizationManager.localizedString(.wind),
                             value: "\(weather.wind.speed) m/s")
                WeatherDataRow(title: localizationManager.localizedString(.pressure),
                             value: "\(weather.main.pressure) hPa")
                WeatherDataRow(title: localizationManager.localizedString(.visibility),
                             value: "\(weather.visibility / 1000) km")
                WeatherDataRow(title: localizationManager.localizedString(.sunrise),
                             value: formatTime(weather.sys.sunrise))
                WeatherDataRow(title: localizationManager.localizedString(.sunset),
                             value: formatTime(weather.sys.sunset))
                WeatherDataRow(title: localizationManager.localizedString(.lastUpdated),
                             value: formatTime(weather.dt))
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.2))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .onAppear {
            updateTime()
        }
        .onReceive(timer) { _ in
            updateTime()
        }
    }
    
    private func updateTime() {
        currentTime = viewModel.getCurrentLocalTime(for: weather.timezone)
    }
    
    private func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

private struct TemperatureInfo: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
        }
    }
}

private struct ForecastView: View {
    let forecast: ForecastResponse
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(localizationManager.localizedString(.forecast))
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecast.list) { item in
                        ForecastItemView(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.2))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

private struct ForecastItemView: View {
    let item: ForecastItem
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Text(formatDayOfWeek(item.dayOfWeek))
                .font(.headline)
                .foregroundColor(.primary)
            
            if let icon = item.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text("\(Int(item.main.temp))℃")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            Text(item.time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.2))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private func formatDayOfWeek(_ day: String) -> String {
        let today = Calendar.current.isDateInToday(item.date)
        let tomorrow = Calendar.current.isDateInTomorrow(item.date)
        
        if today {
            return localizationManager.localizedString(.today)
        } else if tomorrow {
            return localizationManager.localizedString(.tomorrow)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let dayName = formatter.string(from: item.date).lowercased()
            
            switch dayName {
            case "monday": return localizationManager.localizedString(.monday)
            case "tuesday": return localizationManager.localizedString(.tuesday)
            case "wednesday": return localizationManager.localizedString(.wednesday)
            case "thursday": return localizationManager.localizedString(.thursday)
            case "friday": return localizationManager.localizedString(.friday)
            case "saturday": return localizationManager.localizedString(.saturday)
            case "sunday": return localizationManager.localizedString(.sunday)
            default: return day.prefix(3).capitalized
            }
        }
    }
}

private struct WeatherDataRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
}

private struct LoadingView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text(localizationManager.localizedString(.loading))
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.2))
    }
}

private struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            List(Language.allCases) { language in
                Button(action: {
                    withAnimation {
                        localizationManager.currentLanguage = language
                        dismiss()
                    }
                }) {
                    HStack {
                        Text(language.displayName)
                            .foregroundColor(.primary)
                        Spacer()
                        if language == localizationManager.currentLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.selectLanguage))
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.close)) {
                dismiss()
            })
        }
    }
}

struct JSONDataView: View {
    let jsonData: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(jsonData)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .textSelection(.enabled)
            }
            .navigationTitle(localizationManager.localizedString(.jsonData))
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.close)) {
                dismiss()
            })
        }
    }
} 