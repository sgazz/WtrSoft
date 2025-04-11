# WtrSoft - Aplikacija za vremensku prognozu

WtrSoft je moderna iOS aplikacija za praćenje vremenske prognoze, napisana u SwiftUI-u. Aplikacija pruža detaljne informacije o trenutnom vremenu i 5-dnevnu prognozu za bilo koji grad na svetu.

## Funkcionalnosti

- 🌍 Pretraga vremenske prognoze za bilo koji grad
- 🌡️ Detaljne informacije o trenutnom vremenu
- 📅 5-dnevna vremenska prognoza
- 🕒 Prikaz lokalnog vremena u izabranom gradu
- 🌐 Podrška za više jezika (srpski, engleski, nemački, ruski)
- 📱 Moderni i responzivan dizajn
- 📍 Automatsko otkrivanje lokacije

## Zahtevi

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Instalacija

1. Klonirajte repozitorijum:
```bash
git clone https://github.com/sgazz/WtrSoft.git
```

2. Otvorite projekat u Xcode-u:
```bash
cd WtrSoft
open wthrsoft.xcodeproj
```

3. Kreirajte `Config.swift` fajl:
   - Kopirajte `ExampleConfig.swift` u `Config.swift`
   - Unesite svoj OpenWeather API ključ u `Config.swift`

4. Pokrenite aplikaciju u Xcode-u

## Korišćenje

1. Unesite naziv grada u polje za pretragu
2. Pritisnite dugme "Prikaži" da vidite vremensku prognozu
3. Koristite dugme sa ikonom globusa da promenite jezik aplikacije

## Struktura projekta

- `WeatherView.swift` - Glavni view aplikacije
- `WeatherViewModel.swift` - ViewModel za upravljanje podacima
- `Localization.swift` - Upravljanje lokalizacijom
- `Config.swift` - Konfiguracioni fajl (API ključ)
- `ExampleConfig.swift` - Primer konfiguracionog fajla

## API

Aplikacija koristi OpenWeather API za dobijanje vremenskih podataka. Potreban vam je API ključ koji možete dobiti na [OpenWeather](https://openweathermap.org/api).

## Licenca

Ovaj projekat je licenciran pod MIT licencom - pogledajte [LICENSE](LICENSE) fajl za detalje.

## Autor

- **Gazza** - *Inicijalni razvoj* - [sgazz](https://github.com/sgazz)

## Zahvalnice

- [OpenWeather](https://openweathermap.org/) za API
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) za UI framework 