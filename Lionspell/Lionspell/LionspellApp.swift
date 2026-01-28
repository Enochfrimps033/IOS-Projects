//
//  LionspellApp.swift
//  Lionspell
//
//  Created by Haley Parker on 1/22/26.
//

import SwiftUI

@main
struct LionspellApp: App {
    @State var manager:GameManager=GameManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(manager)
        }
    }
}
