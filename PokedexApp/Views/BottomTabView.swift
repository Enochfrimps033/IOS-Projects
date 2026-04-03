//
//  BottomTabView.swift
//  PokedexApp
//
//  Created by Haley Parker on 4/2/26.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            TypesView()
                .tabItem {
                    Label("Types", systemImage: "square.grid.2x2")
                }

            AccountView().tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}

#Preview {
    BottomTabView()
        
}
