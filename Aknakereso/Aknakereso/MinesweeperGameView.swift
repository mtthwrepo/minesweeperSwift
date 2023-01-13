//
//  MinesweeperGameView.swift
//  Aknakereso
//
//  Created by Laczkó Máté on 2023. 01. 08..
//

import SwiftUI

struct MinesweeperGameView: View {
    @ObservedObject var game: MinesweeperViewModel
    @State var gameDifficoulty: Int = MinesweeperConstants.easyModeBombCount
    
    var body: some View {
        VStack {
            HStack {
                Text("Dif: \(getGameDifficoultyAsString())")
                Spacer()
                restart
                Spacer()
                
                let remainingBombs: Int = gameDifficoulty - game.fields.filter({ $0.isMarked }).count
                Text("Unmarked Bombs: \(remainingBombs)")
            }
            .padding(.horizontal)
            
            gameBody
            
            HStack {
                Button("Easy") {
                    gameDifficoulty = MinesweeperConstants.easyModeBombCount
                    game.restart(gameDifficoulty)
                }
                Spacer()
                Button("Medium") {
                    gameDifficoulty = MinesweeperConstants.mediumModeBombCount
                    game.restart(gameDifficoulty)
                    
                }
                Spacer()
                Button("Hard") {
                    gameDifficoulty = MinesweeperConstants.hardModeBombCount
                    game.restart(gameDifficoulty)
                }
            }
            .padding(.horizontal)
            .buttonStyle(.bordered)
        }
    }
    
    func getGameDifficoultyAsString() -> String {
        var difficoultyAsString = ""
        
        if gameDifficoulty == MinesweeperConstants.easyModeBombCount {
            difficoultyAsString = "Easy"
        }
        else if gameDifficoulty == MinesweeperConstants.mediumModeBombCount {
            difficoultyAsString = "Medium"
        }
        else {
            difficoultyAsString = "Hard"
        }
        
        return difficoultyAsString
    }
    
    var gameBody: some View {
        AspectHGrid(items: game.fields, aspectRatio: 1/1) { field in
            FieldView(field: field)
                .onTapGesture {
                    game.choose(field)
                }
                .onLongPressGesture {
                    game.mark(field)
                }
        }
        .padding()
        .foregroundColor(.black)
    }

    struct FieldView: View {
        let field: MinesweeperViewModel.Field
        
        var body: some View {
                Text(field.content)
                .fieldify(isChecked: field.isChecked, isMarked: field.isMarked)
        }
    }
    
    var restart: some View {
        var buttonContent = "😃"
        if game.isWon { buttonContent = "😎" }
        else if !game.isPlaying { buttonContent = "☠️" }
        
        return Button(buttonContent) {
                //withAnimation {
            game.restart(gameDifficoulty)
                //}
            }
        .buttonStyle(.bordered)
        
    }
}



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MinesweeperViewModel()
        MinesweeperGameView(game: game)
            .previewInterfaceOrientation(.portrait)
    }
}
