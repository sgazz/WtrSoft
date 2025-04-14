import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    let onLocationSelected: (Location) -> Void
    
    var body: some View {
        NavigationView {
            List {
                if favoritesManager.favorites.isEmpty {
                    Text(localizationManager.localizedString(.noFavorites))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(favoritesManager.favorites) { location in
                        Button(action: {
                            onLocationSelected(location)
                            dismiss()
                        }) {
                            HStack {
                                Text(location.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let location = favoritesManager.favorites[index]
                            favoritesManager.removeFavorite(location)
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.favorites))
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