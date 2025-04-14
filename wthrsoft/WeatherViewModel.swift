//
//  WeatherViewModel.swift
//  wthrsoft
//
//  Created by Gazza on 11. 4. 2025..
//

// WeatherViewModel.swift
import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var cityName: String = "London"
    @Published var jsonData: String = ""
    @Published var currentWeather: WeatherResponse?
    @Published var error: Error?
    private let locationManager = CLLocationManager()
    private let apiKey = Config.apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5"

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func fetchWeather(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // Fetch current weather
        let weatherURL = "\(baseURL)/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: weatherURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherResponse.self, from: data)
                    self?.weather = weather
                    self?.cityName = weather.name
                    
                    // Nakon uspešnog učitavanja trenutnog vremena, učitaj prognozu
                    self?.fetchForecast(for: city)
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }
    
    private func fetchForecast(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let forecastURL = "\(baseURL)/forecast?q=\(encodedCity)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: forecastURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(ForecastResponse.self, from: data)
                    self?.forecast = forecast
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
            fetchWeatherData(from: urlString)
            
            let forecastUrlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
            fetchForecastData(from: forecastUrlString)
        }
    }

    private func fetchWeatherData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                // Čuvamo JSON string
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self?.jsonData = self?.formatJSON(jsonString) ?? ""
                    }
                }
                
                // Dekodiramo podatke
                if let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self?.weather = decoded
                        self?.cityName = decoded.name
                    }
                }
            }
        }.resume()
    }
    
    private func fetchForecastData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data,
               let decoded = try? JSONDecoder().decode(ForecastResponse.self, from: data) {
                DispatchQueue.main.async {
                    self?.forecast = decoded
                }
            }
        }.resume()
    }
    
    private func formatJSON(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return jsonString
        }
        return prettyString
    }

    func getCurrentLocalTime(for timezone: Int) -> String {
        let date = Date()
        let timeZone = TimeZone(secondsFromGMT: timezone) ?? TimeZone.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        
        return formatter.string(from: date)
    }

    private func metersPerSecondToKilometersPerHour(_ mps: Double) -> Double {
        return mps * 3.6 // 1 m/s = 3.6 km/h
    }
}

// Model structures
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
    let visibility: Int
    let dt: TimeInterval
    let timezone: Int
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Sys: Codable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let country: String
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

// Forecast structures
struct ForecastResponse: Codable {
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt_txt: String
    
    var id: TimeInterval { dt }
    
    var date: Date {
        Date(timeIntervalSince1970: dt)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct City: Codable {
    let name: String
    let country: String
    let timezone: Int
}
