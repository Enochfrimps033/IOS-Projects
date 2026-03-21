//
//  ContentView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/18/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = BuildingViewModel()
    
    var body: some View {
        TabView {
            BuildingListView(viewModel: viewModel)
                .tabItem {
                    Label("Buildings", systemImage: "building.2")
                }

            CampusView(viewModel: viewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(LocationManager())
}
