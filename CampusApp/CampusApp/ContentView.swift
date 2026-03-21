//
//  ContentView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/18/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = BuildingViewModel()
    @State private var selectedTab = 1   // 0 = Buildings, 1 = Map

    var body: some View {
        TabView(selection: $selectedTab) {
            BuildingListView(viewModel: viewModel)
                .tabItem {
                    Label("Buildings", systemImage: "building.2")
                }
                .tag(0)

            CampusView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
        .environment(LocationManager())
}
