import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("useMetricSystem") private var useMetricSystem = true
    @AppStorage("showNotifications") private var showNotifications = true
    @AppStorage("updateInterval") private var updateInterval = 30 // minuti
    @AppStorage("selectedTheme") private var selectedTheme = "auto"
    @AppStorage("showMoonDetails") private var showMoonDetails = true
    @AppStorage("showWindDetails") private var showWindDetails = true
    @AppStorage("showPressureDetails") private var showPressureDetails = true
    @AppStorage("enableAnimations") private var enableAnimations = true
    @AppStorage("animationSpeed") private var animationSpeed = "normal"
    @AppStorage("collectUsageData") private var collectUsageData = true
    @AppStorage("locationAccess") private var locationAccess = true
    
    var body: some View {
        NavigationView {
            List {
                // Jezička podešavanja
                Section(header: Text(localizationManager.localizedString(.language))) {
                    Picker(selection: $localizationManager.currentLanguage) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    } label: {
                        Label(localizationManager.localizedString(.selectLanguage),
                              systemImage: "globe")
                    }
                }
                
                // Tema
                Section(header: Text(localizationManager.localizedString(.theme))) {
                    Picker(selection: $selectedTheme) {
                        Text(localizationManager.localizedString(.themeAuto)).tag("auto")
                        Text(localizationManager.localizedString(.themeLight)).tag("light")
                        Text(localizationManager.localizedString(.themeDark)).tag("dark")
                        Text(localizationManager.localizedString(.themeSystem)).tag("system")
                    } label: {
                        Label(localizationManager.localizedString(.selectTheme),
                              systemImage: "paintbrush")
                    }
                }
                
                // Sistem merenja
                Section(header: Text(localizationManager.localizedString(.units))) {
                    Toggle(isOn: $useMetricSystem) {
                        Label(localizationManager.localizedString(.useMetric),
                              systemImage: "ruler")
                    }
                }
                
                // Prikaz podataka
                Section(header: Text(localizationManager.localizedString(.dataDisplay))) {
                    Toggle(isOn: $showMoonDetails) {
                        Label(localizationManager.localizedString(.showMoonDetails),
                              systemImage: "moon.stars")
                    }
                    Toggle(isOn: $showWindDetails) {
                        Label(localizationManager.localizedString(.showWindDetails),
                              systemImage: "wind")
                    }
                    Toggle(isOn: $showPressureDetails) {
                        Label(localizationManager.localizedString(.showPressureDetails),
                              systemImage: "gauge.medium")
                    }
                }
                
                // Animacije
                Section(header: Text(localizationManager.localizedString(.animations))) {
                    Toggle(isOn: $enableAnimations) {
                        Label(localizationManager.localizedString(.enableAnimations),
                              systemImage: "sparkles")
                    }
                    if enableAnimations {
                        Picker(selection: $animationSpeed) {
                            Text(localizationManager.localizedString(.animationSpeedFast)).tag("fast")
                            Text(localizationManager.localizedString(.animationSpeedNormal)).tag("normal")
                            Text(localizationManager.localizedString(.animationSpeedSlow)).tag("slow")
                        } label: {
                            Label(localizationManager.localizedString(.animationSpeed),
                                  systemImage: "speedometer")
                        }
                    }
                }
                
                // Notifikacije
                Section(header: Text(localizationManager.localizedString(.notifications))) {
                    Toggle(isOn: $showNotifications) {
                        Label(localizationManager.localizedString(.enableNotifications),
                              systemImage: "bell.fill")
                    }
                }
                
                // Interval ažuriranja
                Section(header: Text(localizationManager.localizedString(.updateSettings))) {
                    Picker(selection: $updateInterval) {
                        Text("15 \(localizationManager.localizedString(.minutes))").tag(15)
                        Text("30 \(localizationManager.localizedString(.minutes))").tag(30)
                        Text("60 \(localizationManager.localizedString(.minutes))").tag(60)
                    } label: {
                        Label(localizationManager.localizedString(.updateInterval),
                              systemImage: "clock")
                    }
                }
                
                // Privatnost
                Section(header: Text(localizationManager.localizedString(.privacy))) {
                    Toggle(isOn: $collectUsageData) {
                        Label(localizationManager.localizedString(.collectUsageData),
                              systemImage: "chart.bar")
                    }
                    Toggle(isOn: $locationAccess) {
                        Label(localizationManager.localizedString(.locationAccess),
                              systemImage: "location")
                    }
                }
                
                // O aplikaciji
                Section(header: Text(localizationManager.localizedString(.about))) {
                    HStack {
                        Text(localizationManager.localizedString(.version))
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.settings))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                }
            }
        }
    }
} 