import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case german = "de"
    case russian = "ru"
    case serbian = "sr"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .german: return "Deutsch"
        case .russian: return "Русский"
        case .serbian: return "Srpski"
        }
    }
}

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    static let shared = LocalizationManager()
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .serbian
        }
    }
    
    func localizedString(_ key: LocalizationKey) -> String {
        return key.localizedString(for: currentLanguage)
    }
}

enum LocalizationKey {
    case enterCity
    case show
    case loading
    case temperature
    case minTemp
    case maxTemp
    case feelsLike
    case description
    case humidity
    case wind
    case pressure
    case visibility
    case sunrise
    case sunset
    case lastUpdated
    case forecast
    case today
    case tomorrow
    case close
    case selectLanguage
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    case currentTime
    case jsonData
    case moonPhase
    case newMoon
    case waxingCrescent
    case firstQuarter
    case waxingGibbous
    case fullMoon
    case waningGibbous
    case lastQuarter
    case waningCrescent
    case moon
    case moonIllumination
    case moonRise
    case moonSet
    case settings
    case language
    case units
    case useMetric
    case notifications
    case enableNotifications
    case updateSettings
    case updateInterval
    case minutes
    case about
    case version
    case done
    case theme
    case themeLight
    case themeDark
    case themeSystem
    case selectTheme
    case dataDisplay
    case showMoonDetails
    case showWindDetails
    case showPressureDetails
    case animations
    case enableAnimations
    case animationSpeed
    case animationSpeedFast
    case animationSpeedNormal
    case animationSpeedSlow
    case privacy
    case collectUsageData
    case locationAccess
    case showTemperature
    case showHumidity
    case showWind
    case favorites
    case noFavorites
    case addToFavorites
    case removeFromFavorites
    case delete
    
    func localizedString(for language: Language) -> String {
        switch language {
        case .english:
            return englishString
        case .german:
            return germanString
        case .russian:
            return russianString
        case .serbian:
            return serbianString
        }
    }
    
    private var englishString: String {
        switch self {
        case .enterCity: return "Enter city"
        case .show: return "Show"
        case .loading: return "Loading..."
        case .temperature: return "Temperature"
        case .minTemp: return "Min"
        case .maxTemp: return "Max"
        case .feelsLike: return "Feels like"
        case .description: return "Description"
        case .humidity: return "Humidity"
        case .wind: return "Wind"
        case .pressure: return "Pressure"
        case .visibility: return "Visibility"
        case .sunrise: return "Sunrise"
        case .sunset: return "Sunset"
        case .lastUpdated: return "Last updated"
        case .forecast: return "5-Day Forecast"
        case .today: return "Today"
        case .tomorrow: return "Tomorrow"
        case .close: return "Close"
        case .selectLanguage: return "Select Language"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        case .currentTime: return "Current time"
        case .jsonData: return "JSON Data"
        case .moonPhase: return "Moon Phase"
        case .newMoon: return "New Moon"
        case .waxingCrescent: return "Waxing Crescent"
        case .firstQuarter: return "First Quarter"
        case .waxingGibbous: return "Waxing Gibbous"
        case .fullMoon: return "Full Moon"
        case .waningGibbous: return "Waning Gibbous"
        case .lastQuarter: return "Last Quarter"
        case .waningCrescent: return "Waning Crescent"
        case .moon: return "Moon"
        case .moonIllumination: return "Illumination"
        case .moonRise: return "Moonrise"
        case .moonSet: return "Moonset"
        case .settings: return "Settings"
        case .language: return "Language"
        case .units: return "Units"
        case .useMetric: return "Use Metric System"
        case .notifications: return "Notifications"
        case .enableNotifications: return "Enable Notifications"
        case .updateSettings: return "Update Settings"
        case .updateInterval: return "Update Interval"
        case .minutes: return "minutes"
        case .about: return "About"
        case .version: return "Version"
        case .done: return "Done"
        case .theme: return "Theme"
        case .themeLight: return "Light"
        case .themeDark: return "Dark"
        case .themeSystem: return "System"
        case .selectTheme: return "Select Theme"
        case .dataDisplay: return "Data Display"
        case .showMoonDetails: return "Show Moon Details"
        case .showWindDetails: return "Show Wind Details"
        case .showPressureDetails: return "Show Pressure Details"
        case .animations: return "Animations"
        case .enableAnimations: return "Enable Animations"
        case .animationSpeed: return "Animation Speed"
        case .animationSpeedFast: return "Fast"
        case .animationSpeedNormal: return "Normal"
        case .animationSpeedSlow: return "Slow"
        case .privacy: return "Privacy"
        case .collectUsageData: return "Collect Usage Data"
        case .locationAccess: return "Location Access"
        case .showTemperature: return "Show Temperature"
        case .showHumidity: return "Show Humidity"
        case .showWind: return "Show Wind"
        case .favorites: return "Favorites"
        case .noFavorites: return "No favorite locations"
        case .addToFavorites: return "Add to Favorites"
        case .removeFromFavorites: return "Remove from Favorites"
        case .delete: return "Delete"
        }
    }
    
    private var germanString: String {
        switch self {
        case .enterCity: return "Stadt eingeben"
        case .show: return "Anzeigen"
        case .loading: return "Laden..."
        case .temperature: return "Temperatur"
        case .minTemp: return "Min"
        case .maxTemp: return "Max"
        case .feelsLike: return "Gefühlt"
        case .description: return "Beschreibung"
        case .humidity: return "Luftfeuchtigkeit"
        case .wind: return "Wind"
        case .pressure: return "Luftdruck"
        case .visibility: return "Sichtweite"
        case .sunrise: return "Sonnenaufgang"
        case .sunset: return "Sonnenuntergang"
        case .lastUpdated: return "Zuletzt aktualisiert"
        case .forecast: return "5-Tage-Vorhersage"
        case .today: return "Heute"
        case .tomorrow: return "Morgen"
        case .close: return "Schließen"
        case .selectLanguage: return "Sprache auswählen"
        case .monday: return "Montag"
        case .tuesday: return "Dienstag"
        case .wednesday: return "Mittwoch"
        case .thursday: return "Donnerstag"
        case .friday: return "Freitag"
        case .saturday: return "Samstag"
        case .sunday: return "Sonntag"
        case .currentTime: return "Aktuelle Zeit"
        case .jsonData: return "JSON Daten"
        case .moonPhase: return "Mondphase"
        case .newMoon: return "Neumond"
        case .waxingCrescent: return "Zunehmender Sichelmond"
        case .firstQuarter: return "Erstes Viertel"
        case .waxingGibbous: return "Zunehmender Mond"
        case .fullMoon: return "Vollmond"
        case .waningGibbous: return "Abnehmender Mond"
        case .lastQuarter: return "Letztes Viertel"
        case .waningCrescent: return "Abnehmender Sichelmond"
        case .moon: return "Mond"
        case .moonIllumination: return "Beleuchtung"
        case .moonRise: return "Mondaufgang"
        case .moonSet: return "Monduntergang"
        case .settings: return "Einstellungen"
        case .language: return "Sprache"
        case .units: return "Einheiten"
        case .useMetric: return "Metrisches System verwenden"
        case .notifications: return "Benachrichtigungen"
        case .enableNotifications: return "Benachrichtigungen aktivieren"
        case .updateSettings: return "Aktualisierungseinstellungen"
        case .updateInterval: return "Aktualisierungsintervall"
        case .minutes: return "Minuten"
        case .about: return "Über"
        case .version: return "Version"
        case .done: return "Fertig"
        case .theme: return "Thema"
        case .themeLight: return "Hell"
        case .themeDark: return "Dunkel"
        case .themeSystem: return "System"
        case .selectTheme: return "Design auswählen"
        case .dataDisplay: return "Datenanzeige"
        case .showMoonDetails: return "Monddetails anzeigen"
        case .showWindDetails: return "Winddetails anzeigen"
        case .showPressureDetails: return "Druckdetails anzeigen"
        case .animations: return "Animationen"
        case .enableAnimations: return "Animationen aktivieren"
        case .animationSpeed: return "Animationsgeschwindigkeit"
        case .animationSpeedFast: return "Schnell"
        case .animationSpeedNormal: return "Normal"
        case .animationSpeedSlow: return "Langsam"
        case .privacy: return "Datenschutz"
        case .collectUsageData: return "Nutzungsdaten sammeln"
        case .locationAccess: return "Standortzugriff"
        case .showTemperature: return "Temperatur anzeigen"
        case .showHumidity: return "Luftfeuchtigkeit anzeigen"
        case .showWind: return "Wind anzeigen"
        case .favorites: return "Favoriten"
        case .noFavorites: return "Keine Favoriten"
        case .addToFavorites: return "Zu Favoriten hinzufügen"
        case .removeFromFavorites: return "Aus Favoriten entfernen"
        case .delete: return "Löschen"
        }
    }
    
    private var russianString: String {
        switch self {
        case .enterCity: return "Введите город"
        case .show: return "Показать"
        case .loading: return "Загрузка..."
        case .temperature: return "Температура"
        case .minTemp: return "Мин"
        case .maxTemp: return "Макс"
        case .feelsLike: return "Ощущается как"
        case .description: return "Описание"
        case .humidity: return "Влажность"
        case .wind: return "Ветер"
        case .pressure: return "Давление"
        case .visibility: return "Видимость"
        case .sunrise: return "Восход"
        case .sunset: return "Закат"
        case .lastUpdated: return "Обновлено"
        case .forecast: return "Прогноз на 5 дней"
        case .today: return "Сегодня"
        case .tomorrow: return "Завтра"
        case .close: return "Закрыть"
        case .selectLanguage: return "Выберите язык"
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        case .currentTime: return "Текущее время"
        case .jsonData: return "JSON Данные"
        case .moonPhase: return "Фаза Луны"
        case .newMoon: return "Новолуние"
        case .waxingCrescent: return "Растущий серп"
        case .firstQuarter: return "Первая четверть"
        case .waxingGibbous: return "Растущая Луна"
        case .fullMoon: return "Полнолуние"
        case .waningGibbous: return "Убывающая Луна"
        case .lastQuarter: return "Последняя четверть"
        case .waningCrescent: return "Убывающий серп"
        case .moon: return "Луна"
        case .moonIllumination: return "Освещённость"
        case .moonRise: return "Восход Луны"
        case .moonSet: return "Заход Луны"
        case .settings: return "Настройки"
        case .language: return "Язык"
        case .units: return "Единицы измерения"
        case .useMetric: return "Использовать метрическую систему"
        case .notifications: return "Уведомления"
        case .enableNotifications: return "Включить уведомления"
        case .updateSettings: return "Настройки обновления"
        case .updateInterval: return "Интервал обновления"
        case .minutes: return "минут"
        case .about: return "О приложении"
        case .version: return "Версия"
        case .done: return "Готово"
        case .theme: return "Тема"
        case .themeLight: return "Светлая"
        case .themeDark: return "Тёмная"
        case .themeSystem: return "Системная"
        case .selectTheme: return "Выберите тему"
        case .dataDisplay: return "Отображение данных"
        case .showMoonDetails: return "Показывать детали Луны"
        case .showWindDetails: return "Показывать детали ветра"
        case .showPressureDetails: return "Показывать детали давления"
        case .animations: return "Анимации"
        case .enableAnimations: return "Включить анимации"
        case .animationSpeed: return "Скорость анимации"
        case .animationSpeedFast: return "Быстро"
        case .animationSpeedNormal: return "Нормально"
        case .animationSpeedSlow: return "Медленно"
        case .privacy: return "Конфиденциальность"
        case .collectUsageData: return "Сбор данных об использовании"
        case .locationAccess: return "Доступ к местоположению"
        case .showTemperature: return "Показывать температуру"
        case .showHumidity: return "Показывать влажность"
        case .showWind: return "Показывать ветер"
        case .favorites: return "Избранное"
        case .noFavorites: return "Нет избранных мест"
        case .addToFavorites: return "Добавить в избранное"
        case .removeFromFavorites: return "Удалить из избранного"
        case .delete: return "Удалить"
        }
    }
    
    private var serbianString: String {
        switch self {
        case .enterCity: return "Unesite grad"
        case .show: return "Prikaži"
        case .loading: return "Učitavanje..."
        case .temperature: return "Temperatura"
        case .minTemp: return "Min"
        case .maxTemp: return "Max"
        case .feelsLike: return "Oseća se kao"
        case .description: return "Opis"
        case .humidity: return "Vlažnost"
        case .wind: return "Vetar"
        case .pressure: return "Pritisak"
        case .visibility: return "Vidljivost"
        case .sunrise: return "Izlazak sunca"
        case .sunset: return "Zalazak sunca"
        case .lastUpdated: return "Poslednje ažuriranje"
        case .forecast: return "Prognoza za 5 dana"
        case .today: return "Danas"
        case .tomorrow: return "Sutra"
        case .close: return "Zatvori"
        case .selectLanguage: return "Izaberite jezik"
        case .monday: return "Ponedeljak"
        case .tuesday: return "Utorak"
        case .wednesday: return "Sreda"
        case .thursday: return "Četvrtak"
        case .friday: return "Petak"
        case .saturday: return "Subota"
        case .sunday: return "Nedelja"
        case .currentTime: return "Trenutno vreme"
        case .jsonData: return "JSON Podaci"
        case .moonPhase: return "Faza Meseca"
        case .newMoon: return "Mladi Mesec"
        case .waxingCrescent: return "Rastući Srp"
        case .firstQuarter: return "Prva Četvrt"
        case .waxingGibbous: return "Rastući Mesec"
        case .fullMoon: return "Pun Mesec"
        case .waningGibbous: return "Opadajući Mesec"
        case .lastQuarter: return "Poslednja Četvrt"
        case .waningCrescent: return "Opadajući Srp"
        case .moon: return "Mesec"
        case .moonIllumination: return "Osvetljenost"
        case .moonRise: return "Izlazak Meseca"
        case .moonSet: return "Zalazak Meseca"
        case .settings: return "Podešavanja"
        case .language: return "Jezik"
        case .units: return "Jedinice"
        case .useMetric: return "Koristi metrički sistem"
        case .notifications: return "Obaveštenja"
        case .enableNotifications: return "Uključi obaveštenja"
        case .updateSettings: return "Podešavanja ažuriranja"
        case .updateInterval: return "Interval ažuriranja"
        case .minutes: return "minuta"
        case .about: return "O aplikaciji"
        case .version: return "Verzija"
        case .done: return "Gotovo"
        case .theme: return "Тема"
        case .themeLight: return "Светла"
        case .themeDark: return "Тамна"
        case .themeSystem: return "Системска"
        case .selectTheme: return "Izaberite temu"
        case .dataDisplay: return "Prikaz podataka"
        case .showMoonDetails: return "Prikazati detalje o mesecu"
        case .showWindDetails: return "Prikazati detalje o vetru"
        case .showPressureDetails: return "Prikazati detalje o pritisku"
        case .animations: return "Animacije"
        case .enableAnimations: return "Uključiti animacije"
        case .animationSpeed: return "Brzina animacija"
        case .animationSpeedFast: return "Brzo"
        case .animationSpeedNormal: return "Normalno"
        case .animationSpeedSlow: return "Sporo"
        case .privacy: return "Privatnost"
        case .collectUsageData: return "Prikupljanje podataka o korišćenju"
        case .locationAccess: return "Pristup lokaciji"
        case .showTemperature: return "Prikazati temperaturu"
        case .showHumidity: return "Prikazati vlažnost"
        case .showWind: return "Prikazati vetar"
        case .favorites: return "Омиљене локације"
        case .noFavorites: return "Нема омиљених локација"
        case .addToFavorites: return "Додај у омиљене"
        case .removeFromFavorites: return "Уклоni iz omiљeniх"
        case .delete: return "Обриши"
        }
    }
} 
