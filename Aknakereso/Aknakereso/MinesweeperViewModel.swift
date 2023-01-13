//
//  MinesweeperViewModel.swift
//  Aknakereso
//
//  Created by Laczkó Máté on 2023. 01. 08..
//

import SwiftUI

public struct MinesweeperConstants {
    static let defaultFieldContent = ""
    static let bombSign = "💣"
    static let allFieldsCount = 120
    static let easyModeBombCount = 10
    static let mediumModeBombCount = 15
    static let hardModeBombCount = 20
}

class MinesweeperViewModel: ObservableObject {
    typealias Field = Minesweeper<String>.Field
    
    private static func createMinesweeperGame(_ bombCount: Int) -> Minesweeper<String> {
        let filedContents = fieldContentCreator(bombCount: bombCount)
        
        return Minesweeper<String> { fieldIndex in
            filedContents[fieldIndex]
        }
    }
    
    private static func fieldContentCreator(bombCount: Int) -> Array<String> {
        var fieldContents = Array<String>()
        
        for num in 0..<MinesweeperConstants.allFieldsCount { //allFieldsCount = 120
            if num < bombCount {
                fieldContents.append(MinesweeperConstants.bombSign)
            } else {
                fieldContents.append(MinesweeperConstants.defaultFieldContent)
            }
        }
        
        fieldContents.shuffle()
        
        for index in fieldContents.indices {
            if fieldContents[index] != MinesweeperConstants.bombSign {
                let surroundingFieldContents = Minesweeper<String>.getSurroundings(index, fieldContents)
                let bombs = surroundingFieldContents.filter({ $0 == MinesweeperConstants.bombSign })
                
                if bombs.count > 0 {
                    fieldContents[index] = "\(bombs.count)"
                }
            }
        }
        
        return fieldContents
    }
    
    @Published private var model = createMinesweeperGame(MinesweeperConstants.easyModeBombCount)
    
    var fields: Array<Field> { model.fields }
    var isPlaying: Bool { model.isPlaying }
    var isWon: Bool { model.isWon }
    
    //MARK: - Intent(s)
    
    func choose(_ field: Field) {
        model.choose(field, MinesweeperConstants.defaultFieldContent, MinesweeperConstants.bombSign)
    }
    
    func mark(_ field: Field) {
            model.mark(field)
    }
    
    func restart(_ bombCount: Int) {
        model = MinesweeperViewModel.createMinesweeperGame(bombCount)
    }
}
