import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [FavoriteLocation] = []
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteLocations"
    
    static let shared = FavoritesManager()
    
    private init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: favoritesKey),
              let decodedFavorites = try? JSONDecoder().decode([FavoriteLocation].self, from: data) else {
            return
        }
        favorites = decodedFavorites
    }
    
    private func saveFavorites() {
        guard let encoded = try? JSONEncoder().encode(favorites) else { return }
        userDefaults.set(encoded, forKey: favoritesKey)
        objectWillChange.send()
    }
    
    func addFavorite(name: String, latitude: Double, longitude: Double) {
        let newLocation = FavoriteLocation(name: name, latitude: latitude, longitude: longitude)
        if !favorites.contains(where: { $0.name == name }) {
            favorites.append(newLocation)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ location: FavoriteLocation) {
        favorites.removeAll { $0.id == location.id }
        saveFavorites()
    }
    
    func isFavorite(name: String) -> Bool {
        favorites.contains { $0.name == name }
    }
} 