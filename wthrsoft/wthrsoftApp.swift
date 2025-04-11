//
//  wthrsoftApp.swift
//  wthrsoft
//
//  Created by Gazza on 11. 4. 2025..
//

import SwiftUI

@main
struct wthrsoftApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environmentObject(themeManager)
        }
    }
}
