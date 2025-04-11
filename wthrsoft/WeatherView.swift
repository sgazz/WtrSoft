import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguagePicker = false
    @State private var showingJSONData = false
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            // Moderniji gradijent sa više boja
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1E90FF").opacity(0.8),  // Dodger Blue
                    Color(hex: "4B0082").opacity(0.5),  // Indigo
                    Color(hex: "00BFFF").opacity(0.3)   // Deep Sky Blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animirani pozadinski oblaci
            GeometryReader { geometry in
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.width * CGFloat([0.8, 0.6, 0.7][index]))
                        .offset(x: geometry.size.width * CGFloat([-0.2, 0.4, 0.1][index]),
                               y: geometry.size.height * CGFloat([-0.2, 0.4, 0.2][index]))
                        .blur(radius: CGFloat([60, 50, 40][index]))
                        .modifier(FloatingAnimation(duration: Double([7, 5, 6][index])))
                }
            }
            
            ScrollView {
                VStack(spacing: 25) {
                    // Kontrole
                    VStack(spacing: 20) {
                        // Dugmad za jezik i JSON
                        HStack(spacing: 15) {
                            Spacer()
                            Button(action: { showingLanguagePicker = true }) {
                                Image(systemName: "globe")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .shadow(color: Color.black.opacity(0.1), radius: 5)
                                    )
                            }
                            
                            Button(action: { showingJSONData = true }) {
                                Image(systemName: "curlybraces")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .shadow(color: Color.black.opacity(0.1), radius: 5)
                                    )
                            }
                        }
                        
                        // Search bar sa poboljšanim dizajnom
                        HStack(spacing: 15) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                
                                TextField(localizationManager.localizedString(.enterCity), text: $viewModel.cityName)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .onChange(of: viewModel.cityName) { oldValue, newValue in
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            isSearching = true
                                        }
                                    }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.9))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    isSearching = false
                                    viewModel.fetchWeather(for: viewModel.cityName)
                                }
                            }) {
                                Text(localizationManager.localizedString(.show))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "1E90FF"), Color(hex: "4169E1")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                            .shadow(color: Color(hex: "1E90FF").opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                            }
                            .scaleEffect(isSearching ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearching)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let weather = viewModel.weather {
                        WeatherInfoView(weather: weather)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                        
                        if let forecast = viewModel.forecast {
                            ForecastView(forecast: forecast)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    } else {
                        LoadingView()
                            .transition(.scale.combined(with: .opacity))
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
                .preferredColorScheme(.light)
        }
        .sheet(isPresented: $showingJSONData) {
            JSONDataView(jsonData: viewModel.jsonData)
                .preferredColorScheme(.light)
        }
    }
}

// MARK: - Subviews
private struct WeatherInfoView: View {
    let weather: WeatherResponse
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var viewModel = WeatherViewModel()
    @State private var currentTime = ""
    @State private var isAppeared = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var weatherCondition: String {
        weather.weather.first?.description ?? ""
    }
    
    private var themeColor: Color {
        Color.weatherThemeColor(for: weatherCondition)
    }
    
    private var temperatureSection: some View {
        VStack(spacing: 20) {
            Text("\(Int(weather.main.temp))℃")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(themeColor)
                .shadow(color: .white.opacity(0.2), radius: 5)
                .scaleEffect(isAppeared ? 1 : 0.5)
            
            HStack(spacing: 30) {
                TemperatureInfo(
                    title: localizationManager.localizedString(.minTemp),
                    value: "\(Int(weather.main.temp_min))℃",
                    icon: "thermometer.low",
                    delay: 0.1,
                    condition: weatherCondition
                )
                TemperatureInfo(
                    title: localizationManager.localizedString(.maxTemp),
                    value: "\(Int(weather.main.temp_max))℃",
                    icon: "thermometer.high",
                    delay: 0.2,
                    condition: weatherCondition
                )
                TemperatureInfo(
                    title: localizationManager.localizedString(.feelsLike),
                    value: "\(Int(weather.main.feels_like))℃",
                    icon: "thermometer.medium",
                    delay: 0.3,
                    condition: weatherCondition
                )
            }
        }
    }
    
    private var weatherDetailsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
            WeatherDataRow(
                title: localizationManager.localizedString(.description),
                value: weatherCondition.capitalized,
                icon: "cloud.fill",
                delay: 0.1,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.humidity),
                value: "\(weather.main.humidity)%",
                icon: "humidity.fill",
                delay: 0.2,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.wind),
                value: "\(weather.wind.speed) m/s",
                icon: "wind",
                delay: 0.3,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.pressure),
                value: "\(weather.main.pressure) hPa",
                icon: "gauge.medium",
                delay: 0.4,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.visibility),
                value: "\(weather.visibility / 1000) km",
                icon: "eye.fill",
                delay: 0.5,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.sunrise),
                value: formatTime(weather.sys.sunrise),
                icon: "sunrise.fill",
                delay: 0.6,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.sunset),
                value: formatTime(weather.sys.sunset),
                icon: "sunset.fill",
                delay: 0.7,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.lastUpdated),
                value: formatTime(weather.dt),
                icon: "clock.fill",
                delay: 0.8,
                condition: weatherCondition
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Header section
            VStack(spacing: 12) {
                Text("\(weather.name), \(weather.sys.country)")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(themeColor)
                    .shadow(color: .white.opacity(0.2), radius: 2)
                    .scaleEffect(isAppeared ? 1 : 0.8)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(themeColor.opacity(0.8))
                    Text("\(localizationManager.localizedString(.currentTime)): \(currentTime)")
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(themeColor.opacity(0.8))
                }
                .scaleEffect(isAppeared ? 1 : 0.8)
                
                if let icon = weather.weather.first?.icon {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .shadow(color: .white.opacity(0.2), radius: 10)
                            .scaleEffect(isAppeared ? 1 : 0.5)
                            .rotationEffect(.degrees(isAppeared ? 0 : 180))
                    } placeholder: {
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
            
            temperatureSection
            weatherDetailsGrid
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.05))
                        .blur(radius: 20)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 15)
        )
        .padding(.horizontal)
        .onAppear {
            updateTime()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppeared = true
            }
        }
        .onReceive(timer) { _ in updateTime() }
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
    let icon: String
    let delay: Double
    let condition: String
    @State private var isAppeared = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(minWidth: 80)
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                isAppeared = true
            }
        }
    }
}

private struct ForecastView: View {
    let forecast: ForecastResponse
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedItem: ForecastItem?
    @State private var isAppeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(localizationManager.localizedString(.forecast))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(forecast.list.indices, id: \.self) { index in
                        let item = forecast.list[index]
                        ForecastItemView(item: item,
                                       isSelected: selectedItem?.id == item.id,
                                       delay: Double(index) * 0.1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedItem = selectedItem?.id == item.id ? nil : item
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.05))
                        .blur(radius: 20)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 15)
        )
        .padding(.horizontal)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppeared = true
            }
        }
    }
}

private struct ForecastItemView: View {
    let item: ForecastItem
    let isSelected: Bool
    let delay: Double
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var isAppeared = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text(formatDayOfWeek(item.dayOfWeek))
                .font(.headline)
                .foregroundColor(.white)
            
            if let icon = item.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .shadow(color: .white.opacity(0.2), radius: 5)
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                }
            }
            
            Text("\(Int(item.main.temp))℃")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(item.time)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            if isSelected {
                VStack(spacing: 10) {
                    WeatherDetailRow(icon: "thermometer.low", value: "\(Int(item.main.temp_min))℃")
                    WeatherDetailRow(icon: "thermometer.high", value: "\(Int(item.main.temp_max))℃")
                    WeatherDetailRow(icon: "humidity.fill", value: "\(item.main.humidity)%")
                    WeatherDetailRow(icon: "wind", value: "\(Int(item.wind.speed))m/s")
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 110)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(isSelected ? 0.2 : 0.1))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: isSelected ? 1 : 0)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10)
        )
        .scaleEffect(isSelected ? 1.05 : 1)
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 50)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                isAppeared = true
            }
        }
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

private struct WeatherDetailRow: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

private struct WeatherDataRow: View {
    let title: String
    let value: String
    let icon: String
    let delay: Double
    let condition: String
    @State private var isAppeared = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                isAppeared = true
            }
        }
    }
}

private struct LoadingView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 25) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            Text(localizationManager.localizedString(.loading))
                .font(.title2)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(50)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .shadow(color: Color.black.opacity(0.1), radius: 15)
        )
        .padding(.horizontal)
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

struct FloatingAnimation: ViewModifier {
    let duration: Double
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? -10 : 10)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static func weatherThemeColor(for condition: String) -> Color {
        switch condition.lowercased() {
        case let c where c.contains("clear"):
            return Color(hex: "FFD700")  // Sunčano žuta
        case let c where c.contains("sun"):
            return Color(hex: "FFA500")  // Narandžasta za sunce
        case let c where c.contains("cloud"):
            return Color.white.opacity(0.9)  // Sjajno bela za oblake
        case let c where c.contains("rain"):
            return Color(hex: "00CED1")  // Tirkizna za kišu
        case let c where c.contains("thunder"):
            return Color(hex: "9370DB")  // Srednje ljubičasta za grmljavinu
        case let c where c.contains("snow"):
            return Color(hex: "E0FFFF")  // Svetlo plava za sneg
        case let c where c.contains("mist") || c.contains("fog"):
            return Color(hex: "B0C4DE")  // Svetlo čelično plava za maglu
        case let c where c.contains("drizzle"):
            return Color(hex: "87CEEB")  // Nebo plava za rosulja
        default:
            return .white  // Podrazumevana bela
        }
    }
} 