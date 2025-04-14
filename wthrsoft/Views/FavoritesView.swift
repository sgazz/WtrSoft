import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    var onLocationSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.background
                    .ignoresSafeArea()
                
                List {
                    if favoritesManager.favorites.isEmpty {
                        Text(localizationManager.localizedString(.noFavorites))
                            .foregroundColor(themeManager.currentTheme.text)
                            .fontWeight(.medium)
                    } else {
                        ForEach(favoritesManager.favorites) { location in
                            Button(action: {
                                onLocationSelected(location.name)
                                dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(location.name)
                                            .foregroundColor(themeManager.currentTheme.text)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                        Text("\(location.latitude), \(location.longitude)")
                                            .font(.system(size: 14))
                                            .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(themeManager.currentTheme.accent)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .listRowBackground(themeManager.currentTheme.cardBackground)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    favoritesManager.removeFavorite(location)
                                } label: {
                                    Label(localizationManager.localizedString(.delete), systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle(localizationManager.localizedString(.favorites))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.close)) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.accent)
                }
            }
        }
    }
} 