import Foundation

struct FavoriteLocation: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    
    init(name: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date()
    }
    
    static func == (lhs: FavoriteLocation, rhs: FavoriteLocation) -> Bool {
        lhs.id == rhs.id
    }
} 