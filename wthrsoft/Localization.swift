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
        case .serbian: return "Српски"
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
        }
    }
} 