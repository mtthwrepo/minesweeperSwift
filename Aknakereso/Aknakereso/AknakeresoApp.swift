//
//  AknakeresoApp.swift
//  Aknakereso
//
//  Created by Laczkó Máté on 2023. 01. 08..
//

import SwiftUI

@main
struct AknakeresoApp: App {
    var body: some Scene {
        WindowGroup {
            let game = MinesweeperViewModel()
            MinesweeperGameView(game: game)
        }
    }
}
