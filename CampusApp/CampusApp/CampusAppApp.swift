//
//  CampusAppApp.swift
//  CampusApp
//
//  Created by Haley Parker on 3/18/26.
//

import SwiftUI

@main
struct CampusAppApp: App {
    @State private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(locationManager)
        }
    }
}
