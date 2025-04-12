import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedLanguage = "sr"
    @State private var selectedTheme = "auto"
    @State private var showTemperature = true
    @State private var showHumidity = true
    @State private var showWind = true
    @State private var animationsEnabled = true
    @State private var locationEnabled = true
    @State private var deviceDataEnabled = true
    
    private var isDarkMode: Bool {
        switch selectedTheme {
        case "dark":
            return true
        case "light":
            return false
        case "system":
            return colorScheme == .dark
        default: // "auto"
            let calendar = Calendar.current
            let now = Date()
            let hour = calendar.component(.hour, from: now)
            
            switch hour {
            case 5..<7: return false  // dawn
            case 7..<11: return false // morning
            case 11..<15: return false // noon
            case 15..<19: return false // evening
            case 19..<21: return true  // sunset
            default: return true      // night
            }
        }
    }
    
    private var backgroundColor: LinearGradient {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        
        switch selectedTheme {
        case "light":
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFFFFF").opacity(0.9),
                    Color(hex: "F0F0F0").opacity(0.8),
                    Color(hex: "E0E0E0").opacity(0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "dark":
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "000000").opacity(0.9),
                    Color(hex: "1C1C1E").opacity(0.8),
                    Color(hex: "2C2C2E").opacity(0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "system":
            return colorScheme == .dark ? ThemeColors.dark.background : ThemeColors.light.background
        default: // "auto"
            switch hour {
            case 5..<7: // dawn
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FFB6C1").opacity(0.8),
                        Color(hex: "FFA07A").opacity(0.6),
                        Color(hex: "FFE4E1").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case 7..<11: // morning
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "87CEEB").opacity(0.8),
                        Color(hex: "B0E0E6").opacity(0.6),
                        Color(hex: "F0F8FF").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case 11..<15: // noon
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FFD700").opacity(0.8),
                        Color(hex: "FFA500").opacity(0.6),
                        Color(hex: "FFE4B5").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case 15..<19: // evening
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FF8C00").opacity(0.8),
                        Color(hex: "FF4500").opacity(0.6),
                        Color(hex: "FFD700").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case 19..<21: // sunset
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FF6347").opacity(0.8),
                        Color(hex: "FF4500").opacity(0.6),
                        Color(hex: "8B0000").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            default: // night
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "191970").opacity(0.8),
                        Color(hex: "000080").opacity(0.6),
                        Color(hex: "000000").opacity(0.4)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.6)
    }
    
    private var accentColor: Color {
        isDarkMode ? Color(red: 0.4, green: 0.7, blue: 1.0) : Color(red: 0.0, green: 0.5, blue: 1.0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        settingsSection(title: localizationManager.localizedString(.language), icon: "globe") {
                            languagePicker
                        }
                        
                        settingsSection(title: localizationManager.localizedString(.theme), icon: "paintbrush") {
                            themePicker
                        }
                        
                        settingsSection(title: localizationManager.localizedString(.dataDisplay), icon: "chart.bar") {
                            dataDisplayOptions
                        }
                        
                        settingsSection(title: localizationManager.localizedString(.animations), icon: "sparkles") {
                            animationToggle
                        }
                        
                        settingsSection(title: localizationManager.localizedString(.privacy), icon: "lock.shield") {
                            privacyOptions
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(localizationManager.localizedString(.settings))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveSettings) {
                        Text(localizationManager.localizedString(.done))
                            .foregroundColor(accentColor)
                    }
                }
            }
            .onAppear {
                // Učitaj sačuvane vrednosti
                selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "auto"
                showTemperature = UserDefaults.standard.bool(forKey: "showTemperature")
                showHumidity = UserDefaults.standard.bool(forKey: "showHumidity")
                showWind = UserDefaults.standard.bool(forKey: "showWind")
                animationsEnabled = UserDefaults.standard.bool(forKey: "animationsEnabled")
                locationEnabled = UserDefaults.standard.bool(forKey: "locationEnabled")
                deviceDataEnabled = UserDefaults.standard.bool(forKey: "deviceDataEnabled")
            }
        }
    }
    
    private func settingsSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(accentColor)
                Text(title)
                    .font(.headline)
                    .foregroundColor(textColor)
            }
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isDarkMode ? Color(red: 0.17, green: 0.17, blue: 0.19) : .white)
                .shadow(
                    color: isDarkMode ? Color.black.opacity(0.4) : Color.black.opacity(0.1),
                    radius: isDarkMode ? 10 : 5,
                    x: 0,
                    y: isDarkMode ? 4 : 2
                )
        )
    }
    
    private var languagePicker: some View {
        Picker("", selection: $localizationManager.currentLanguage) {
            ForEach(Language.allCases) { language in
                Text(language.displayName)
                    .tag(language)
                    .foregroundColor(textColor)
            }
        }
        .pickerStyle(.segmented)
        .tint(accentColor)
    }
    
    private var themePicker: some View {
        Picker("", selection: $selectedTheme) {
            Text(localizationManager.localizedString(.themeAuto)).tag("auto")
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.themeLight)).tag("light")
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.themeDark)).tag("dark")
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.themeSystem)).tag("system")
                .foregroundColor(textColor)
        }
        .pickerStyle(.segmented)
        .tint(accentColor)
        .onChange(of: selectedTheme) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "selectedTheme")
            NotificationCenter.default.post(name: NSNotification.Name("ThemeChanged"), object: nil)
            withAnimation(.easeInOut(duration: 0.3)) {
                themeManager.objectWillChange.send()
            }
        }
    }
    
    private var dataDisplayOptions: some View {
        VStack(spacing: 15) {
            Toggle(isOn: $showTemperature) {
                Text(LocalizationKey.showTemperature.localizedString(for: localizationManager.currentLanguage))
            }
            .onChange(of: showTemperature) { oldValue, newValue in
                UserDefaults.standard.set(newValue, forKey: "showTemperature")
            }
            
            Toggle(isOn: $showHumidity) {
                Text(LocalizationKey.showHumidity.localizedString(for: localizationManager.currentLanguage))
            }
            .onChange(of: showHumidity) { oldValue, newValue in
                UserDefaults.standard.set(newValue, forKey: "showHumidity")
            }
            
            Toggle(isOn: $showWind) {
                Text(LocalizationKey.showWind.localizedString(for: localizationManager.currentLanguage))
            }
            .onChange(of: showWind) { oldValue, newValue in
                UserDefaults.standard.set(newValue, forKey: "showWind")
            }
        }
    }
    
    private var animationToggle: some View {
        Toggle(localizationManager.localizedString(.enableAnimations), isOn: $animationsEnabled)
            .onChange(of: animationsEnabled) { _, newValue in
                UserDefaults.standard.set(newValue, forKey: "animationsEnabled")
            }
    }
    
    private var privacyOptions: some View {
        VStack(spacing: 15) {
            Toggle(localizationManager.localizedString(.locationAccess), isOn: $locationEnabled)
                .onChange(of: locationEnabled) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "locationEnabled")
                }
            
            Toggle(localizationManager.localizedString(.collectUsageData), isOn: $deviceDataEnabled)
                .onChange(of: deviceDataEnabled) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "deviceDataEnabled")
                }
        }
    }
    
    private func saveSettings() {
        // Sačuvaj sve promene
        UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
        UserDefaults.standard.set(showTemperature, forKey: "showTemperature")
        UserDefaults.standard.set(showHumidity, forKey: "showHumidity")
        UserDefaults.standard.set(showWind, forKey: "showWind")
        UserDefaults.standard.set(animationsEnabled, forKey: "animationsEnabled")
        UserDefaults.standard.set(locationEnabled, forKey: "locationEnabled")
        UserDefaults.standard.set(deviceDataEnabled, forKey: "deviceDataEnabled")
        
        // Objavi promene
        NotificationCenter.default.post(name: NSNotification.Name("ThemeChanged"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("SettingsChanged"), object: nil)
        
        // Zatvori view
        dismiss()
    }
}

#Preview {
    SettingsView()
} 