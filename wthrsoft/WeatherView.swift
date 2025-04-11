import SwiftUI

enum TimeOfDay {
    case dawn      // 5:00 - 7:00
    case morning   // 7:00 - 11:00
    case noon      // 11:00 - 15:00
    case evening   // 15:00 - 19:00
    case sunset    // 19:00 - 21:00
    case night     // 21:00 - 5:00
    
    static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<7: return .dawn
        case 7..<11: return .morning
        case 11..<15: return .noon
        case 15..<19: return .evening
        case 19..<21: return .sunset
        default: return .night
        }
    }
}

struct ThemeColors {
    let background: LinearGradient
    let text: Color
    let accent: Color
    let secondary: Color
    let cardBackground: Color
    
    static func current(timezone: TimeZone? = nil) -> ThemeColors {
        let calendar = Calendar.current
        let now = Date()
        let timezone = timezone ?? TimeZone.current
        
        // Konvertujemo datum u vremensku zonu grada
        let cityDate = now.addingTimeInterval(TimeInterval(timezone.secondsFromGMT() - TimeZone.current.secondsFromGMT()))
        let hour = calendar.component(.hour, from: cityDate)
        
        switch hour {
        case 5..<7: return .dawn
        case 7..<11: return .morning
        case 11..<15: return .noon
        case 15..<19: return .evening
        case 19..<21: return .sunset
        default: return .night
        }
    }
    
    static var dawn: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFB6C1").opacity(0.8),  // Svetlo ružičasta
                    Color(hex: "FFA07A").opacity(0.6),  // Svetlo losos
                    Color(hex: "FFE4E1").opacity(0.4)   // Svetlo ružičasta
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "4A4A4A"),
            accent: Color(hex: "FF69B4"),
            secondary: Color(hex: "FFB6C1"),
            cardBackground: Color.white.opacity(0.2)
        )
    }
    
    static var morning: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "87CEEB").opacity(0.8),  // Nebo plava
                    Color(hex: "B0E0E6").opacity(0.6),  // Prašina plava
                    Color(hex: "F0F8FF").opacity(0.4)   // Alice plava
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "2F4F4F"),
            accent: Color(hex: "1E90FF"),
            secondary: Color(hex: "87CEEB"),
            cardBackground: Color.white.opacity(0.2)
        )
    }
    
    static var noon: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFD700").opacity(0.8),  // Zlatno žuta
                    Color(hex: "FFA500").opacity(0.6),  // Narandžasta
                    Color(hex: "FFE4B5").opacity(0.4)   // Mokej
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "8B4513"),
            accent: Color(hex: "FFD700"),
            secondary: Color(hex: "FFA500"),
            cardBackground: Color.white.opacity(0.2)
        )
    }
    
    static var evening: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF8C00").opacity(0.8),  // Tamno narandžasta
                    Color(hex: "FF4500").opacity(0.6),  // Crveno narandžasta
                    Color(hex: "FFD700").opacity(0.4)   // Zlatno žuta
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "4A4A4A"),
            accent: Color(hex: "FF8C00"),
            secondary: Color(hex: "FF4500"),
            cardBackground: Color.white.opacity(0.2)
        )
    }
    
    static var sunset: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF6347").opacity(0.8),  // Tomat
                    Color(hex: "FF4500").opacity(0.6),  // Crveno narandžasta
                    Color(hex: "8B0000").opacity(0.4)   // Tamno crvena
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "FFFFFF"),
            accent: Color(hex: "FF6347"),
            secondary: Color(hex: "FF4500"),
            cardBackground: Color.white.opacity(0.15)
        )
    }
    
    static var night: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "191970").opacity(0.8),  // Ponoćno plava
                    Color(hex: "000080").opacity(0.6),  // Mornarsko plava
                    Color(hex: "000000").opacity(0.4)   // Crna
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "E0FFFF"),
            accent: Color(hex: "87CEEB"),
            secondary: Color(hex: "B0C4DE"),
            cardBackground: Color.white.opacity(0.1)
        )
    }
}

// Dodajemo timer za ažuriranje teme
class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeColors
    private var timer: Timer?
    private var cityTimezone: TimeZone?
    
    init() {
        self.currentTheme = ThemeColors.current()
        startTimer()
    }
    
    func updateTimezone(_ timezone: TimeZone) {
        self.cityTimezone = timezone
        updateTheme()
    }
    
    private func updateTheme() {
        currentTheme = ThemeColors.current(timezone: cityTimezone)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager()
    @State private var showingLanguagePicker = false
    @State private var showingJSONData = false
    @State private var isSearching = false
    
    // Izdvajamo pozadinu u zasebnu computed property
    private var backgroundView: some View {
        ZStack {
            themeManager.currentTheme.background
                .ignoresSafeArea()
            
            // Animirani pozadinski oblaci
            GeometryReader { geometry in
                ForEach(0..<3) { index in
                    Circle()
                        .fill(themeManager.currentTheme.cardBackground)
                        .frame(width: geometry.size.width * CGFloat([0.8, 0.6, 0.7][index]))
                        .offset(x: geometry.size.width * CGFloat([-0.2, 0.4, 0.1][index]),
                               y: geometry.size.height * CGFloat([-0.2, 0.4, 0.2][index]))
                        .blur(radius: CGFloat([60, 50, 40][index]))
                        .modifier(FloatingAnimation(duration: Double([7, 5, 6][index])))
                }
            }
        }
    }
    
    // Izdvajamo kontrole u zasebnu computed property
    private var controlsView: some View {
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
    }
    
    // Izdvajamo prikaz vremena u zasebnu computed property
    private var weatherContentView: some View {
        Group {
            if let weather = viewModel.weather {
                WeatherInfoView(weather: weather)
                    .environmentObject(themeManager)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                
                if let forecast = viewModel.forecast {
                    TemperatureChartView(forecast: forecast)
                        .environmentObject(themeManager)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    ForecastView(forecast: forecast)
                        .environmentObject(themeManager)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            } else {
                LoadingView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    var body: some View {
        ZStack {
            backgroundView
            
            ScrollView {
                VStack(spacing: 25) {
                    controlsView
                    weatherContentView
                }
                .padding(.vertical)
            }
        }
        .environmentObject(themeManager)
        .onAppear {
            withAnimation {
                viewModel.fetchWeather(for: viewModel.cityName)
            }
        }
        .onChange(of: viewModel.weather) { _, newValue in
            if let weather = newValue {
                let timezone = TimeZone(secondsFromGMT: weather.timezone) ?? TimeZone.current
                themeManager.updateTimezone(timezone)
            }
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView()
                .preferredColorScheme(.light)
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showingJSONData) {
            JSONDataView(jsonData: viewModel.jsonData)
                .preferredColorScheme(.light)
                .environmentObject(themeManager)
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
    @EnvironmentObject private var themeManager: ThemeManager
    
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
            weatherDetailRows
        }
    }
    
    private var weatherDetailRows: some View {
        Group {
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
                    .foregroundColor(themeManager.currentTheme.text)
                    .shadow(color: themeManager.currentTheme.accent.opacity(0.2), radius: 2)
                    .scaleEffect(isAppeared ? 1 : 0.8)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(themeManager.currentTheme.accent.opacity(0.8))
                    Text("\(localizationManager.localizedString(.currentTime)): \(currentTime)")
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(themeManager.currentTheme.accent.opacity(0.8))
                }
                .scaleEffect(isAppeared ? 1 : 0.8)
                
                if let weatherCondition = weather.weather.first?.description {
                    AnimatedWeatherIcon(condition: weatherCondition)
                        .scaleEffect(isAppeared ? 1 : 0.5)
                        .rotationEffect(.degrees(isAppeared ? 0 : 180))
                }
            }
            
            temperatureSection
            weatherDetailsGrid
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(themeManager.currentTheme.cardBackground)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(themeManager.currentTheme.cardBackground.opacity(0.5))
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

private struct TemperatureChartView: View {
    let forecast: ForecastResponse
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isAppeared = false
    
    private var next24Hours: [ForecastItem] {
        let now = Date()
        return forecast.list
            .filter { $0.date > now }
            .prefix(8)
            .map { $0 }
    }
    
    private var temperatureRange: (min: Double, max: Double) {
        let temps = next24Hours.map { $0.main.temp }
        return (temps.min() ?? 0, temps.max() ?? 0)
    }
    
    private func normalizedTemperature(_ temp: Double) -> Double {
        let range = temperatureRange.max - temperatureRange.min
        return range == 0 ? 0.5 : (temp - temperatureRange.min) / range
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("24h Temperature")
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.text)
                .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    // Pozadinska linija
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.6))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height * 0.6))
                    }
                    .stroke(themeManager.currentTheme.text.opacity(0.2), lineWidth: 1)
                    
                    // Temperaturna linija
                    Path { path in
                        let points = next24Hours.enumerated().map { index, item in
                            CGPoint(
                                x: CGFloat(index) * (geometry.size.width / CGFloat(next24Hours.count - 1)),
                                y: geometry.size.height * 0.6 * (1 - CGFloat(normalizedTemperature(item.main.temp)))
                            )
                        }
                        
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                themeManager.currentTheme.accent,
                                themeManager.currentTheme.secondary
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    
                    // Tačke sa temperaturama
                    HStack(spacing: 0) {
                        ForEach(next24Hours.indices, id: \.self) { index in
                            let item = next24Hours[index]
                            let y = geometry.size.height * 0.6 * (1 - CGFloat(normalizedTemperature(item.main.temp)))
                            
                            VStack(spacing: 1) {
                                Text("\(Int(item.main.temp))°")
                                    .font(.system(size: 10))
                                    .foregroundColor(themeManager.currentTheme.text)
                                
                                Circle()
                                    .fill(themeManager.currentTheme.accent)
                                    .frame(width: 4, height: 4)
                                
                                Text(item.time)
                                    .font(.system(size: 8))
                                    .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                            }
                            .frame(width: geometry.size.width / CGFloat(next24Hours.count))
                            .offset(y: y - 15)
                            .opacity(isAppeared ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1 * Double(index)), value: isAppeared)
                        }
                    }
                }
            }
            .frame(height: 80)
            .padding(.horizontal, 5)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.cardBackground.opacity(0.5))
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
        .padding(.horizontal)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(localizationManager.localizedString(.forecast))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.text)
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
                .fill(themeManager.currentTheme.cardBackground)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(themeManager.currentTheme.cardBackground.opacity(0.5))
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var weatherIcon: String {
        if let condition = item.weather.first?.description {
            switch condition.lowercased() {
            case let c where c.contains("clear sky"):
                return "sun.max.fill"
            case let c where c.contains("few clouds"):
                return "cloud.sun.fill"
            case let c where c.contains("scattered clouds"):
                return "cloud.fill"
            case let c where c.contains("broken clouds"):
                return "smoke.fill"
            case let c where c.contains("shower rain"):
                return "cloud.heavyrain.fill"
            case let c where c.contains("rain"):
                return "cloud.rain.fill"
            case let c where c.contains("thunderstorm"):
                return "cloud.bolt.rain.fill"
            case let c where c.contains("snow"):
                return "snow"
            case let c where c.contains("mist") || c.contains("fog"):
                return "cloud.fog.fill"
            case let c where c.contains("drizzle"):
                return "cloud.drizzle.fill"
            default:
                return "cloud.fill"
            }
        }
        return "cloud.fill"
    }
    
    private var iconColor: Color {
        if let condition = item.weather.first?.description {
            switch condition.lowercased() {
            case let c where c.contains("clear sky"):
                return .yellow
            case let c where c.contains("clouds"):
                return .white
            case let c where c.contains("rain"):
                return .blue
            case let c where c.contains("thunderstorm"):
                return .purple
            case let c where c.contains("snow"):
                return .white
            case let c where c.contains("mist") || c.contains("fog"):
                return .white.opacity(0.8)
            default:
                return .white
            }
        }
        return .white
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text(formatDayOfWeek(item.dayOfWeek))
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.text)
            
            Image(systemName: weatherIcon)
                .font(.system(size: 40))
                .foregroundStyle(iconColor.gradient)
                .shadow(color: iconColor.opacity(0.3), radius: 5)
            
            Text("\(Int(item.main.temp))℃")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.text)
            
            Text(item.time)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
            
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
                .fill(themeManager.currentTheme.cardBackground)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(themeManager.currentTheme.accent.opacity(0.2), lineWidth: isSelected ? 1 : 0)
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.accent.opacity(0.8))
            Text(value)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.text)
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(themeManager.currentTheme.accent.opacity(0.8))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                Text(value)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.text)
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 25) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(themeManager.currentTheme.accent)
            Text(localizationManager.localizedString(.loading))
                .font(.title2)
                .foregroundColor(themeManager.currentTheme.text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(50)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(themeManager.currentTheme.cardBackground)
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

// Menjamo Equatable konformans za WeatherResponse
extension WeatherResponse: Equatable {
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        lhs.name == rhs.name && lhs.dt == rhs.dt
    }
}

private struct AnimatedWeatherIcon: View {
    let condition: String
    @State private var isAnimating = false
    @State private var isHovering = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var systemImage: String {
        switch condition.lowercased() {
        case let c where c.contains("clear sky"):
            return "sun.max.fill"
        case let c where c.contains("few clouds"):
            return "cloud.sun.fill"
        case let c where c.contains("scattered clouds"):
            return "cloud.fill"
        case let c where c.contains("broken clouds"):
            return "smoke.fill"
        case let c where c.contains("shower rain"):
            return "cloud.heavyrain.fill"
        case let c where c.contains("rain"):
            return "cloud.rain.fill"
        case let c where c.contains("thunderstorm"):
            return "cloud.bolt.rain.fill"
        case let c where c.contains("snow"):
            return "snow"
        case let c where c.contains("mist") || c.contains("fog"):
            return "cloud.fog.fill"
        case let c where c.contains("drizzle"):
            return "cloud.drizzle.fill"
        default:
            return "cloud.fill"
        }
    }
    
    private var iconColor: Color {
        switch condition.lowercased() {
        case let c where c.contains("clear sky"):
            return .yellow
        case let c where c.contains("clouds"):
            return .white
        case let c where c.contains("rain"):
            return .blue
        case let c where c.contains("thunderstorm"):
            return .purple
        case let c where c.contains("snow"):
            return .white
        case let c where c.contains("mist") || c.contains("fog"):
            return .white.opacity(0.8)
        default:
            return .white
        }
    }
    
    private var animation: Animation {
        switch condition.lowercased() {
        case let c where c.contains("clear sky"):
            return .easeInOut(duration: 8).repeatForever(autoreverses: true)
        case let c where c.contains("clouds"):
            return .easeInOut(duration: 10).repeatForever(autoreverses: true)
        case let c where c.contains("rain"):
            return .easeInOut(duration: 8).repeatForever(autoreverses: true)
        case let c where c.contains("thunderstorm"):
            return .easeInOut(duration: 9).repeatForever(autoreverses: true)
        default:
            return .easeInOut(duration: 8).repeatForever(autoreverses: true)
        }
    }
    
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 70))
            .foregroundStyle(iconColor.gradient)
            .offset(y: isHovering ? -5 : 5)
            .shadow(color: iconColor.opacity(0.3), radius: 10, x: 0, y: 5)
            .onAppear {
                withAnimation(animation) {
                    isHovering = true
                }
            }
    }
} 
