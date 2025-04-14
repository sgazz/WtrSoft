import SwiftUI

struct ThemeColors {
    let background: LinearGradient
    let text: Color
    let accent: Color
    let secondary: Color
    let cardBackground: Color
    let cardShadow: Color
    
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
                    Color(hex: "FFB6C1").opacity(0.8),
                    Color(hex: "FFA07A").opacity(0.6),
                    Color(hex: "FFE4E1").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "4A4A4A"),
            accent: Color(hex: "FF69B4"),
            secondary: Color(hex: "FFB6C1"),
            cardBackground: Color.white.opacity(0.2),
            cardShadow: Color.black.opacity(0.1)
        )
    }
    
    static var morning: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "87CEEB").opacity(0.8),
                    Color(hex: "B0E0E6").opacity(0.6),
                    Color(hex: "F0F8FF").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "2F4F4F"),
            accent: Color(hex: "1E90FF"),
            secondary: Color(hex: "87CEEB"),
            cardBackground: Color.white.opacity(0.2),
            cardShadow: Color.black.opacity(0.1)
        )
    }
    
    static var noon: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFD700").opacity(0.8),
                    Color(hex: "FFA500").opacity(0.6),
                    Color(hex: "FFE4B5").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "8B4513"),
            accent: Color(hex: "FFD700"),
            secondary: Color(hex: "FFA500"),
            cardBackground: Color.white.opacity(0.2),
            cardShadow: Color.black.opacity(0.15)
        )
    }
    
    static var evening: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF8C00").opacity(0.8),
                    Color(hex: "FF4500").opacity(0.6),
                    Color(hex: "FFD700").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "4A4A4A"),
            accent: Color(hex: "FF8C00"),
            secondary: Color(hex: "FF4500"),
            cardBackground: Color.white.opacity(0.2),
            cardShadow: Color.black.opacity(0.2)
        )
    }
    
    static var sunset: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF6347").opacity(0.8),
                    Color(hex: "FF4500").opacity(0.6),
                    Color(hex: "8B0000").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "FFFFFF"),
            accent: Color(hex: "FF6347"),
            secondary: Color(hex: "FF4500"),
            cardBackground: Color.white.opacity(0.15),
            cardShadow: Color.black.opacity(0.25)
        )
    }
    
    static var night: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "191970").opacity(0.8),
                    Color(hex: "000080").opacity(0.6),
                    Color(hex: "000000").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "E0FFFF"),
            accent: Color(hex: "87CEEB"),
            secondary: Color(hex: "B0C4DE"),
            cardBackground: Color.white.opacity(0.1),
            cardShadow: Color.black.opacity(0.3)
        )
    }
    
    static var light: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "F0F8FF").opacity(0.8),
                    Color(hex: "E6E6FA").opacity(0.6),
                    Color(hex: "FFFFFF").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "2F4F4F"),
            accent: Color(hex: "4169E1"),
            secondary: Color(hex: "87CEEB"),
            cardBackground: Color.white.opacity(0.2),
            cardShadow: Color.black.opacity(0.1)
        )
    }
    
    static var dark: ThemeColors {
        ThemeColors(
            background: LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2F4F4F").opacity(0.8),
                    Color(hex: "1A1A1A").opacity(0.6),
                    Color(hex: "000000").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            text: Color(hex: "F5F5F5"),
            accent: Color(hex: "00CED1"),
            secondary: Color(hex: "4682B4"),
            cardBackground: Color.white.opacity(0.1),
            cardShadow: Color.black.opacity(0.3)
        )
    }
}

// Dodajemo timer za ažuriranje teme
class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeColors
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    @AppStorage("enableAnimations") private var enableAnimations = true
    @AppStorage("animationSpeed") private var animationSpeed = "normal"
    
    init() {
        self.currentTheme = ThemeColors.system
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateThemeFromSettings),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func updateThemeFromSettings() {
        updateTheme()
    }
    
    private func updateTheme() {
        let newTheme: ThemeColors
        switch selectedTheme {
        case "light":
            newTheme = ThemeColors.light
        case "dark":
            newTheme = ThemeColors.dark
        default: // "system"
            newTheme = ThemeColors.system
        }
        
        if !areThemesEqual(currentTheme, newTheme) {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.currentTheme = newTheme
                }
            }
        }
    }
    
    private func areThemesEqual(_ theme1: ThemeColors, _ theme2: ThemeColors) -> Bool {
        theme1.text == theme2.text &&
        theme1.accent == theme2.accent &&
        theme1.secondary == theme2.secondary &&
        theme1.cardBackground == theme2.cardBackground &&
        theme1.cardShadow == theme2.cardShadow
    }
    
    var animationDuration: Double {
        switch animationSpeed {
        case "fast": return 0.3
        case "slow": return 0.9
        default: return 0.6 // "normal"
        }
    }
    
    var animationResponse: Double {
        switch animationSpeed {
        case "fast": return 0.2
        case "slow": return 0.8
        default: return 0.6 // "normal"
        }
    }
    
    var animationDampingFraction: Double {
        switch animationSpeed {
        case "fast": return 0.5
        case "slow": return 0.9
        default: return 0.7 // "normal"
        }
    }
}

// Dodajemo nove teme
extension ThemeColors {
    static var system: ThemeColors {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        } else {
            return .light
        }
    }
}

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var isSearching = false
    @State private var searchText = ""
    @State private var showingJSONData = false
    @State private var showingLanguagePicker = false
    @State private var showingSettings = false
    @State private var showingFavorites = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var toolbarItems: some View {
        HStack(spacing: 15) {
            Button(action: {
                showingFavorites = true
            }) {
                Image(systemName: "star.fill")
                    .foregroundColor(themeManager.currentTheme.accent)
            }
            
            Button(action: {
                showingLanguagePicker = true
            }) {
                Image(systemName: "globe")
                    .foregroundColor(themeManager.currentTheme.accent)
            }
            
            Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gear")
                    .foregroundColor(themeManager.currentTheme.accent)
            }
        }
    }

    private var weatherHeader: some View {
        HStack {
            Button(action: {
                isSearching = true
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(themeManager.currentTheme.accent)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    showingFavorites = true
                }) {
                    Image(systemName: "list.star")
                        .foregroundColor(themeManager.currentTheme.accent)
                }
                
                Button(action: {
                    if favoritesManager.isFavorite(name: viewModel.cityName) {
                        if let location = favoritesManager.favorites.first(where: { $0.name == viewModel.cityName }) {
                            favoritesManager.removeFavorite(location)
                        }
                    } else {
                        favoritesManager.addFavorite(
                            name: viewModel.cityName,
                            latitude: viewModel.weather?.coord.lat ?? 0,
                            longitude: viewModel.weather?.coord.lon ?? 0
                        )
                    }
                }) {
                    Image(systemName: favoritesManager.isFavorite(name: viewModel.cityName) ? "star.fill" : "star")
                        .foregroundColor(themeManager.currentTheme.accent)
                }
                
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(themeManager.currentTheme.accent)
                }
            }
        }
        .padding(.horizontal)
    }

    private var searchView: some View {
        VStack {
            SearchBar(
                text: $searchText,
                isSearching: $isSearching,
                onSearch: { city in
                    viewModel.fetchWeather(for: city)
                    isSearching = false
                }
            )
            .padding()
            
            if let weather = viewModel.weather {
                WeatherContentView(
                    weather: weather,
                    forecast: viewModel.forecast,
                    isSearching: $isSearching
                )
            }
        }
    }

    var body: some View {
        ZStack {
            themeManager.currentTheme.background
                .ignoresSafeArea()
            
            if isSearching {
                searchView
            } else if let weather = viewModel.weather {
                ScrollView {
                    VStack(spacing: 20) {
                        weatherHeader
                        WeatherInfoView(weather: weather)
                        
                        if let forecast = viewModel.forecast {
                            TemperatureChartView(forecast: forecast)
                                .padding(.horizontal)
                            
                            ForecastView(forecast: forecast)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            } else {
                LoadingView()
            }
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesView { location in
                searchText = location
                viewModel.fetchWeather(for: location)
            }
            .environmentObject(themeManager)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            viewModel.fetchWeather(for: viewModel.cityName)
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
    @AppStorage("showMoonDetails") private var showMoonDetails = true
    @AppStorage("showWindDetails") private var showWindDetails = true
    @AppStorage("showPressureDetails") private var showPressureDetails = true
    @AppStorage("enableAnimations") private var enableAnimations = true
    
    private var weatherCondition: String {
        weather.weather.first?.description ?? ""
    }
    
    private var themeColor: Color {
        Color.weatherThemeColor(for: weatherCondition)
    }
    
    private func moonPhase(for date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        // Približna aproksimacija faze meseca
        switch day % 29 {
        case 0...1: return "moon.stars"
        case 2...6: return "moon.circle"
        case 7...8: return "moon.circle.fill"
        case 9...13: return "moon.circle.fill"
        case 14...15: return "moon.fill"
        case 16...20: return "moon.circle.fill"
        case 21...22: return "moon.circle.fill"
        case 23...28: return "moon.circle"
        default: return "moon.stars"
        }
    }
    
    private func moonPhaseName(for date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = components.day ?? 1
        
        // Mesec ima približno 29.5 dana, pa delimo na 8 faza
        let phase = (day % 30) / 4
        
        switch phase {
        case 0: return localizationManager.localizedString(.newMoon)
        case 1: return localizationManager.localizedString(.waxingCrescent)
        case 2: return localizationManager.localizedString(.firstQuarter)
        case 3: return localizationManager.localizedString(.waxingGibbous)
        case 4: return localizationManager.localizedString(.fullMoon)
        case 5: return localizationManager.localizedString(.waningGibbous)
        case 6: return localizationManager.localizedString(.lastQuarter)
        case 7: return localizationManager.localizedString(.waningCrescent)
        default: return localizationManager.localizedString(.moon)
        }
    }
    
    private func moonIllumination(for date: Date) -> Int {
        // Jednostavna aproksimacija osvetljenosti meseca na osnovu datuma
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = components.day ?? 1
        
        // Mesec ima približno 29.5 dana, pa delimo na 8 faza
        let phase = (day % 30) / 4
        
        // Izračunavanje procenata osvetljenosti za svaku fazu
        switch phase {
        case 0: return 0  // Mladi mesec
        case 1: return 25 // Rastući srp
        case 2: return 50 // Prva četvrt
        case 3: return 75 // Rastući mesec
        case 4: return 100 // Pun mesec
        case 5: return 75 // Opadajući mesec
        case 6: return 50 // Poslednja četvrt
        case 7: return 25 // Opadajući srp
        default: return 50
        }
    }
    
    private func moonRiseSet(for date: Date) -> (rise: String, set: String) {
        // Jednostavna aproksimacija vremena izlaska i zalaska meseca
        // U stvarnosti, ovo zavisi od geografske lokacije i datuma
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = components.day ?? 1
        
        // Mesec ima približno 29.5 dana, pa delimo na 8 faza
        let phase = (day % 30) / 4
        
        // Približna vremena izlaska i zalaska meseca za različite faze
        // Ovo su samo približne vrednosti za ilustraciju
        switch phase {
        case 0: // Mladi mesec
            return ("18:00", "06:00")
        case 1: // Rastući srp
            return ("19:00", "07:00")
        case 2: // Prva četvrt
            return ("20:00", "08:00")
        case 3: // Rastući mesec
            return ("21:00", "09:00")
        case 4: // Pun mesec
            return ("22:00", "10:00")
        case 5: // Opadajući mesec
            return ("23:00", "11:00")
        case 6: // Poslednja četvrt
            return ("00:00", "12:00")
        case 7: // Opadajući srp
            return ("01:00", "13:00")
        default:
            return ("18:00", "06:00")
        }
    }
    
    private var currentTimeSection: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(themeManager.currentTheme.accent)
            Text(localizationManager.localizedString(.currentTime) + ": " + currentTime)
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.text)
        }
        .onReceive(timer) { _ in
            currentTime = viewModel.getCurrentLocalTime(for: weather.timezone)
        }
    }
    
    private var temperatureSection: some View {
        VStack(spacing: 25) {
            Text("\(Int(weather.main.temp))℃")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(themeManager.currentTheme.text.opacity(0.95))
                .shadow(color: themeColor.opacity(0.3), radius: 10)
                .scaleEffect(isAppeared ? 1 : 0.5)
                .padding(.top, 10)
            
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
            .padding(.bottom, 10)
        }
    }
    
    private var weatherDetailsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ],
            spacing: 20
        ) {
            weatherDetailRows
        }
        .padding(.horizontal)
        .padding(.top, 20)
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
                title: localizationManager.localizedString(.lastUpdated),
                value: formatTime(weather.dt),
                icon: "clock.fill",
                delay: 0.2,
                condition: weatherCondition
            )
            if showWindDetails {
                WeatherDataRow(
                    title: localizationManager.localizedString(.wind),
                    value: "\(Int(weather.wind.speed * 3.6)) km/h",
                    icon: "wind",
                    delay: 0.3,
                    condition: weatherCondition
                )
            }
            WeatherDataRow(
                title: localizationManager.localizedString(.humidity),
                value: "\(weather.main.humidity)%",
                icon: "humidity.fill",
                delay: 0.4,
                condition: weatherCondition
            )
            if showPressureDetails {
                WeatherDataRow(
                    title: localizationManager.localizedString(.pressure),
                    value: "\(weather.main.pressure) hPa",
                    icon: "gauge.medium",
                    delay: 0.5,
                    condition: weatherCondition
                )
            }
            WeatherDataRow(
                title: localizationManager.localizedString(.visibility),
                value: "\(weather.visibility / 1000) km",
                icon: "eye.fill",
                delay: 0.6,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.sunrise),
                value: formatTime(weather.sys.sunrise),
                icon: "sunrise.fill",
                delay: 0.7,
                condition: weatherCondition
            )
            WeatherDataRow(
                title: localizationManager.localizedString(.sunset),
                value: formatTime(weather.sys.sunset),
                icon: "sunset.fill",
                delay: 0.8,
                condition: weatherCondition
            )
            if showMoonDetails {
                WeatherDataRow(
                    title: localizationManager.localizedString(.moonPhase),
                    value: moonPhaseName(for: Date()),
                    icon: moonPhase(for: Date()),
                    delay: 0.9,
                    condition: weatherCondition
                )
                WeatherDataRow(
                    title: localizationManager.localizedString(.moonIllumination),
                    value: "\(moonIllumination(for: Date()))%",
                    icon: "moon.stars.fill",
                    delay: 1.0,
                    condition: weatherCondition
                )
                WeatherDataRow(
                    title: localizationManager.localizedString(.moonRise),
                    value: moonRiseSet(for: Date()).rise,
                    icon: "moonrise.fill",
                    delay: 1.1,
                    condition: weatherCondition
                )
                WeatherDataRow(
                    title: localizationManager.localizedString(.moonSet),
                    value: moonRiseSet(for: Date()).set,
                    icon: "moonset.fill",
                    delay: 1.2,
                    condition: weatherCondition
                )
            }
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
                
                currentTimeSection
                
                if let weatherCondition = weather.weather.first?.description {
                    AnimatedWeatherIcon(condition: weatherCondition)
                        .scaleEffect(isAppeared ? 1 : 0.5)
                        .rotationEffect(.degrees(isAppeared ? 0 : 180))
                }
            }
            
            temperatureSection
            weatherDetailsGrid
        }
        .onAppear {
            updateTime()
            if enableAnimations {
                withAnimation(.spring(
                    response: themeManager.animationResponse,
                    dampingFraction: themeManager.animationDampingFraction
                )) {
                    isAppeared = true
                }
            } else {
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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.9))
                .shadow(color: themeManager.currentTheme.text.opacity(0.3), radius: 5)
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.7))
                .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 3)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.95))
                .shadow(color: themeManager.currentTheme.text.opacity(0.3), radius: 5)
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
    @AppStorage("enableAnimations") private var enableAnimations = true
    
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
    
    private func moonPhase(for date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        // Približna aproksimacija faze meseca
        switch day % 29 {
        case 0...1: return "moon.stars"
        case 2...6: return "moon.circle"
        case 7...8: return "moon.circle.fill"
        case 9...13: return "moon.circle.fill"
        case 14...15: return "moon.fill"
        case 16...20: return "moon.circle.fill"
        case 21...22: return "moon.circle.fill"
        case 23...28: return "moon.circle"
        default: return "moon.stars"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
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
                    
                    // Tačke sa temperaturama i fazom meseca
                    HStack(spacing: 0) {
                        ForEach(next24Hours.indices, id: \.self) { index in
                            let item = next24Hours[index]
                            let y = geometry.size.height * 0.6 * (1 - CGFloat(normalizedTemperature(item.main.temp)))
                            
                            VStack(spacing: 1) {
                                // Temperatura
                                Text("\(Int(item.main.temp))°")
                                    .font(.system(size: 10))
                                    .foregroundColor(themeManager.currentTheme.text)
                                
                                // Tačka na liniji
                                Circle()
                                    .fill(themeManager.currentTheme.accent)
                                    .frame(width: 4, height: 4)
                                
                                // Vreme
                                Text(item.time)
                                    .font(.system(size: 8))
                                    .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                            }
                            .frame(width: geometry.size.width / CGFloat(next24Hours.count))
                            .offset(y: y - 15)
                            .opacity(isAppeared ? 1 : 0)
                            .animation(
                                enableAnimations ? .spring(
                                    response: themeManager.animationResponse,
                                    dampingFraction: themeManager.animationDampingFraction
                                ).delay(0.1 * Double(index)) : nil,
                                value: isAppeared
                            )
                        }
                    }
                }
            }
            .frame(height: 70)
            .padding(.horizontal, 5)
        }
        .onAppear {
            if enableAnimations {
                withAnimation(.spring(
                    response: themeManager.animationResponse,
                    dampingFraction: themeManager.animationDampingFraction
                )) {
                    isAppeared = true
                }
            } else {
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
    @AppStorage("enableAnimations") private var enableAnimations = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text(localizationManager.localizedString(.forecast))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.text)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecast.list.indices, id: \.self) { index in
                        let item = forecast.list[index]
                        ForecastItemView(item: item,
                                       isSelected: selectedItem?.id == item.id,
                                       delay: Double(index) * 0.1)
                            .onTapGesture {
                                if enableAnimations {
                                    withAnimation(.spring(
                                        response: themeManager.animationResponse,
                                        dampingFraction: themeManager.animationDampingFraction
                                    )) {
                                        selectedItem = selectedItem?.id == item.id ? nil : item
                                    }
                                } else {
                                    selectedItem = selectedItem?.id == item.id ? nil : item
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: selectedItem != nil ? 300 : 200)
        }
        .onAppear {
            if enableAnimations {
                withAnimation(.spring(
                    response: themeManager.animationResponse,
                    dampingFraction: themeManager.animationDampingFraction
                )) {
                    isAppeared = true
                }
            } else {
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
            case let c where c.contains("wind"):
                return "wind"
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
        VStack(spacing: 12) {
            Text(formatDayOfWeek(item.dayOfWeek))
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.text)
                .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 3)
            
            Image(systemName: weatherIcon)
                .font(.system(size: 35))
                .foregroundStyle(iconColor.gradient)
                .shadow(color: iconColor.opacity(0.5), radius: 8)
            
            Text("\(Int(item.main.temp))℃")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.text)
                .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 3)
            
            Text(item.time)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 2)
            
            if isSelected {
                VStack(spacing: 12) {
                    WeatherDetailRow(icon: "thermometer.low", value: "\(Int(item.main.temp_min))℃")
                    WeatherDetailRow(icon: "thermometer.high", value: "\(Int(item.main.temp_max))℃")
                    WeatherDetailRow(icon: "humidity.fill", value: "\(item.main.humidity)%")
                    WeatherDetailRow(icon: "wind", value: "\(Int(item.wind.speed * 3.6)) km/h")
                }
                .padding(.top, 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 110)
        .padding(.vertical, isSelected ? 20 : 15)
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
                .shadow(color: themeManager.currentTheme.accent.opacity(0.3), radius: 3)
            Text(value)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.text)
                .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 2)
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
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.9))
                .shadow(color: themeManager.currentTheme.accent.opacity(0.3), radius: 5)
            
            VStack(spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.text.opacity(0.7))
                    .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 3)
                Text(value)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.text.opacity(0.9))
                    .shadow(color: themeManager.currentTheme.text.opacity(0.2), radius: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 20)
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
    
    private var isNightTime: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 20
    }
    
    private var animation: Animation {
        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    }
    
    private var systemImage: String {
        let baseCondition = condition.lowercased()
        
        if isNightTime {
            switch baseCondition {
            case let c where c.contains("clear"):
                return "moon.stars.fill"
            case let c where c.contains("few clouds"):
                return "cloud.moon.fill"
            case let c where c.contains("scattered clouds"):
                return "cloud.moon.fill"
            case let c where c.contains("broken clouds"):
                return "cloud.moon.fill"
            case let c where c.contains("shower rain"):
                return "cloud.moon.rain.fill"
            case let c where c.contains("rain"):
                return "cloud.moon.rain.fill"
            case let c where c.contains("thunderstorm"):
                return "cloud.moon.bolt.fill"
            case let c where c.contains("snow"):
                return "cloud.moon.snow.fill"
            case let c where c.contains("mist") || c.contains("fog"):
                return "cloud.fog.fill"
            case let c where c.contains("drizzle"):
                return "cloud.moon.rain.fill"
            default:
                return "moon.fill"
            }
        } else {
            switch baseCondition {
            case let c where c.contains("clear"):
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
                return "sun.max.fill"
            }
        }
    }
    
    private var iconColor: Color {
        if isNightTime {
            switch condition.lowercased() {
            case let c where c.contains("clear"):
                return .white
            case let c where c.contains("clouds"):
                return .white.opacity(0.9)
            case let c where c.contains("rain"):
                return .blue.opacity(0.8)
            case let c where c.contains("thunderstorm"):
                return .purple.opacity(0.9)
            case let c where c.contains("snow"):
                return .white
            case let c where c.contains("mist") || c.contains("fog"):
                return .white.opacity(0.7)
            default:
                return .white
            }
        } else {
            switch condition.lowercased() {
            case let c where c.contains("clear"):
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
    }
    
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 100))
            .foregroundStyle(iconColor.gradient)
            .shadow(color: iconColor.opacity(0.5), radius: 15)
            .offset(y: isHovering ? -5 : 5)
            .padding(.vertical, 20)
            .onAppear {
                withAnimation(animation) {
                    isHovering.toggle()
                }
            }
    }
}

extension View {
    func cardStyle(theme: ThemeColors) -> some View {
        modifier(CardModifier(theme: theme))
    }
}

struct CardModifier: ViewModifier {
    let theme: ThemeColors
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(theme.cardBackground)
                    .shadow(
                        color: theme.cardShadow,
                        radius: 10,
                        x: 0,
                        y: 5
                    )
            )
    }
}

// Dodajemo Equatable za ThemeColors da bismo mogli da poredimo teme
extension ThemeColors: Equatable {
    static func == (lhs: ThemeColors, rhs: ThemeColors) -> Bool {
        // Poredimo samo vrednosti koje možemo porediti
        lhs.text == rhs.text &&
        lhs.accent == rhs.accent &&
        lhs.secondary == rhs.secondary &&
        lhs.cardBackground == rhs.cardBackground &&
        lhs.cardShadow == rhs.cardShadow
    }
}

// Dodajemo novi ButtonStyle za lepši efekat pritiska
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

private struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    let onSearch: (String) -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var localizationManager = LocalizationManager.shared
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.currentTheme.text.opacity(0.6))
            
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(LocalizationKey.enterCity.localizedString(for: localizationManager.currentLanguage))
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.6))
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(themeManager.currentTheme.text)
                .focused($isFocused)
                .onSubmit {
                    if !text.isEmpty {
                        onSearch(text)
                        text = "" // Брисање текста након претраге
                    }
                }
            
            if isSearching {
                Button(action: {
                    text = ""
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.6))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(themeManager.currentTheme.cardBackground.opacity(0.8))
        )
        .onChange(of: isSearching) { oldValue, newValue in
            if newValue {
                isFocused = true
            }
        }
    }
}

struct WeatherContentView: View {
    let weather: WeatherResponse
    let forecast: ForecastResponse?
    @Binding var isSearching: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                WeatherInfoView(weather: weather)
                    .padding(.horizontal)
                
                if let forecast = forecast {
                    TemperatureChartView(forecast: forecast)
                        .padding(.horizontal)
                    
                    ForecastView(forecast: forecast)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
} 
