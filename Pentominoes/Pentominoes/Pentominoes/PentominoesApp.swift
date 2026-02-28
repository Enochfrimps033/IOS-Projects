//
//  PentominoesApp.swift
//  Pentominoes
//
//  Created by Haley Parker on 2/24/26.
//

import SwiftUI

@main
struct PentominoesApp: App {
    @State var manager:GameManager=GameManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(manager)

        }
    }
}
