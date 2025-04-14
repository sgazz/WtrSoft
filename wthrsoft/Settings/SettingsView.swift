import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedLanguage = "sr"
<<<<<<< HEAD
    @State private var selectedTheme = "auto"
=======
    @State private var selectedTheme = "system"
    @State private var showTemperature = true
    @State private var showHumidity = true
    @State private var showWind = true
>>>>>>> feature/improvements
    @State private var animationsEnabled = true
    @State private var locationEnabled = true
    @State private var deviceDataEnabled = true
    @AppStorage("useMetricUnits") private var useMetricUnits = true
    
    private var isDarkMode: Bool {
        switch selectedTheme {
        case "dark":
            return true
        case "light":
            return false
        default: // "system"
            return colorScheme == .dark
        }
    }
    
    private var backgroundColor: LinearGradient {
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
        default: // "system"
            return colorScheme == .dark ? ThemeColors.dark.background : ThemeColors.light.background
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
    
    private var cardBackgroundColor: Color {
        switch selectedTheme {
        case "light":
            return .white
        case "dark":
            return Color(red: 0.17, green: 0.17, blue: 0.19)
        case "system":
            return colorScheme == .dark ? Color(red: 0.17, green: 0.17, blue: 0.19) : .white
        default: // "auto"
            return isDarkMode ? Color(red: 0.17, green: 0.17, blue: 0.19) : .white
        }
    }

    private var pickerBackgroundColor: Color {
        switch selectedTheme {
        case "light":
            return .white
        case "dark":
            return Color(red: 0.2, green: 0.2, blue: 0.22)
        case "system":
            return colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.22) : .white
        default: // "auto"
            return isDarkMode ? Color(red: 0.2, green: 0.2, blue: 0.22) : .white
        }
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
                        
                        settingsSection(title: localizationManager.localizedString(.units), icon: "ruler") {
                            unitsToggle
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
                    Button(localizationManager.localizedString(.done)) {
                        saveSettings()
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Učitaj sačuvane vrednosti
<<<<<<< HEAD
                selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "auto"
                animationsEnabled = UserDefaults.standard.bool(forKey: "enableAnimations")
=======
                selectedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "system"
                showTemperature = UserDefaults.standard.bool(forKey: "showTemperature")
                showHumidity = UserDefaults.standard.bool(forKey: "showHumidity")
                showWind = UserDefaults.standard.bool(forKey: "showWind")
                animationsEnabled = UserDefaults.standard.bool(forKey: "animationsEnabled")
>>>>>>> feature/improvements
                locationEnabled = UserDefaults.standard.bool(forKey: "locationEnabled")
                deviceDataEnabled = UserDefaults.standard.bool(forKey: "deviceDataEnabled")
                useMetricUnits = UserDefaults.standard.bool(forKey: "useMetricUnits")
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
                .fill(cardBackgroundColor)
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
        .background(pickerBackgroundColor)
        .preferredColorScheme(selectedTheme == "light" ? .light : (selectedTheme == "dark" ? .dark : colorScheme))
    }
    
    private var themePicker: some View {
        Picker("", selection: $selectedTheme) {
            Text(localizationManager.localizedString(.themeLight)).tag("light")
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.themeDark)).tag("dark")
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.themeSystem)).tag("system")
                .foregroundColor(textColor)
        }
        .pickerStyle(.segmented)
        .tint(accentColor)
        .background(pickerBackgroundColor)
        .preferredColorScheme(selectedTheme == "light" ? .light : (selectedTheme == "dark" ? .dark : colorScheme))
        .onChange(of: selectedTheme) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "selectedTheme")
            NotificationCenter.default.post(name: NSNotification.Name("ThemeChanged"), object: nil)
            withAnimation(.easeInOut(duration: 0.3)) {
                themeManager.objectWillChange.send()
            }
        }
    }
    
    private var unitsToggle: some View {
        Picker("", selection: $useMetricUnits) {
            Text(localizationManager.localizedString(.metric)).tag(true)
                .foregroundColor(textColor)
            Text(localizationManager.localizedString(.imperial)).tag(false)
                .foregroundColor(textColor)
        }
        .pickerStyle(.segmented)
        .tint(accentColor)
        .background(pickerBackgroundColor)
        .preferredColorScheme(selectedTheme == "light" ? .light : (selectedTheme == "dark" ? .dark : colorScheme))
        .onChange(of: useMetricUnits) { oldValue, newValue in
            UserDefaults.standard.set(newValue, forKey: "useMetricUnits")
            NotificationCenter.default.post(
                name: Notification.Name("UnitsChanged"),
                object: nil,
                userInfo: ["useMetricUnits": newValue]
            )
        }
    }
    
    private var dataDisplayOptions: some View {
        VStack(spacing: 15) {
            // Empty VStack for now
        }
    }
    
    private var animationToggle: some View {
        Toggle(localizationManager.localizedString(.enableAnimations), isOn: $animationsEnabled)
            .onChange(of: animationsEnabled) { _, newValue in
                UserDefaults.standard.set(newValue, forKey: "enableAnimations")
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
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
        UserDefaults.standard.set(animationsEnabled, forKey: "enableAnimations")
        UserDefaults.standard.set(locationEnabled, forKey: "locationEnabled")
        UserDefaults.standard.set(deviceDataEnabled, forKey: "deviceDataEnabled")
        UserDefaults.standard.set(useMetricUnits, forKey: "useMetricUnits")
        
        NotificationCenter.default.post(name: NSNotification.Name("SettingsChanged"), object: nil)
    }
}

#Preview {
    SettingsView()
} 