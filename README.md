# Weather App

A beautiful and modern weather application built with SwiftUI that provides detailed weather information and forecasts.

## Features

- **Real-time Weather Data**: Get current weather conditions for any city worldwide
- **Detailed Weather Information**:
  - Temperature (current, min, max, feels like)
  - Wind speed
  - Humidity
  - Atmospheric pressure
  - Visibility
  - Sunrise and sunset times
  - Moon phase and illumination
  - Moonrise and moonset times

- **Smart UI Features**:
  - Automatic day/night theme switching based on location time
  - Dynamic weather icons that change based on time of day
  - Smooth animations and transitions
  - Responsive layout that adapts to different screen sizes

- **Search Functionality**:
  - Quick city search
  - Real-time weather updates

- **Customization**:
  - Multiple language support (English, German, Russian, Serbian)
  - Theme customization options
  - Display preferences

## Technical Details

- Built with SwiftUI
- Uses OpenWeather API for weather data
- Implements MVVM architecture
- Features reactive programming with Combine
- Handles time zones automatically
- Supports iOS 15.0+

## Installation

1. Clone the repository
2. Open `wthrsoft.xcodeproj` in Xcode
3. Add your OpenWeather API key in `Config.swift`
4. Build and run the project

## Configuration

The app requires an OpenWeather API key to function. To add your API key:

1. Sign up at [OpenWeather](https://openweathermap.org/api)
2. Get your API key
3. Create a `Config.swift` file in the project
4. Add your API key:
```swift
struct Config {
    static let apiKey = "YOUR_API_KEY"
}
```

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Autor

- **Gazza** - *Inicijalni razvoj* - [sgazz](https://github.com/sgazz)

## Zahvalnice

- [OpenWeather](https://openweathermap.org/) za API
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) za UI framework 