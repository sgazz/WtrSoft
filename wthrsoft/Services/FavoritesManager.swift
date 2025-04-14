import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favorites: [Location] = []
    
    private let favoritesKey = "favorites"
    
    private init() {
        loadFavorites()
    }
    
    func addFavorite(_ location: Location) {
        if !isFavorite(name: location.name) {
            favorites.append(location)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ location: Location) {
        favorites.removeAll { $0.name == location.name }
        saveFavorites()
    }
    
    func isFavorite(name: String) -> Bool {
        return favorites.contains { $0.name == name }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            favorites = decoded
        }
    }
}

struct Location: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
} 