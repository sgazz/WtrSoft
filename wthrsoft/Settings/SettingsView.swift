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
        colorScheme == .dark
    }
    
    private var backgroundColor: Color {
        isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        isDarkMode ? .gray : .gray.opacity(0.8)
    }
    
    private var accentColor: Color {
        isDarkMode ? Color(red: 0.4, green: 0.7, blue: 1.0) : Color(red: 0.0, green: 0.5, blue: 1.0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(textColor)
                    }
                }
                
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
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
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
                .fill(isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.17) : .white)
                .shadow(
                    color: isDarkMode ? Color.black.opacity(0.3) : Color.black.opacity(0.1),
                    radius: isDarkMode ? 8 : 5,
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
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var themePicker: some View {
        Picker("", selection: $selectedTheme) {
            Text(localizationManager.localizedString(.themeAuto)).tag("auto")
            Text(localizationManager.localizedString(.themeLight)).tag("light")
            Text(localizationManager.localizedString(.themeDark)).tag("dark")
            Text(localizationManager.localizedString(.themeSystem)).tag("system")
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedTheme) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: "selectedTheme")
            NotificationCenter.default.post(name: NSNotification.Name("ThemeChanged"), object: nil)
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