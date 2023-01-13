//
//  Minesweeper.swift
//  Aknakereso
//
//  Created by Laczkó Máté on 2023. 01. 08..
//

import Foundation
import SwiftUI

struct Minesweeper<FieldContent> where FieldContent: Equatable {
    private(set) var fields: Array<Field>
    private(set) var isPlaying = true
    private(set) var isWon = false
    
    mutating func mark(_ field: Field) {
        if let chosenIndex = fields.firstIndex(where: { $0.id == field.id }), isPlaying {
            fields[chosenIndex].isMarked.toggle()
        }
    }
    
    mutating func choose(_ field: Field, _ emptyFieldContent: FieldContent, _ bombSign: FieldContent) {
        if let chosenIndex = fields.firstIndex(where: { $0.id == field.id }),
           !fields[chosenIndex].isChecked,
           !fields[chosenIndex].isMarked,
           isPlaying
        {
            fields[chosenIndex].isChecked = true
            
            if fields[chosenIndex].content == bombSign {
                // TODO: make the background of the selected bomb red
                
                let bombFieldIndexes = fields.indices.filter({ fields[$0].content == bombSign && !fields[$0].isMarked}) // except the marked ones
                bombFieldIndexes.forEach({ fields[$0].isChecked = true }) //show all bomb when you've lost
                isPlaying = false
            }
            
            if fields[chosenIndex].content == emptyFieldContent {
                let surroundingFields = Minesweeper.getSurroundings(chosenIndex, fields).filter({ !$0.isChecked })
                surroundingFields.forEach({ choose($0, emptyFieldContent, bombSign) })
            }
            
            if fields.filter( { $0.content != bombSign && !$0.isChecked }).count == 0 {
                isWon = true
                isPlaying = false
            }
        }
    }
    
    static func getSurroundings<Element>(_ chosenIndex: Int, _ fields: Array<Element>) -> Array<Element> {
        var surroundings = Array<Element>()
        Minesweeper.getSurroundingIndexes(chosenIndex)
            .filter({ $0 >= 0 && $0 < MinesweeperConstants.allFieldsCount})
            .forEach({ surroundings.append(fields[$0]) })
        
        return surroundings
    }
    
    static func getSurroundingIndexes(_ chosenIndex: Int) -> [Int] { // igen, tudom Marci, hogy ez okádék megoldás és hogy kellene egy x meg egy y
        var surroundingIndexes: [Int] = []
        let chosenPlusOne = chosenIndex + 1
        
        if chosenIndex % 8 == 0 || chosenIndex == 0 { // these are in the first column
            surroundingIndexes = [chosenIndex + 1,
                                       chosenIndex - 7,
                                       chosenIndex - 8,
                                       chosenIndex + 8,
                                       chosenIndex + 9]
        } else if chosenPlusOne % 8 == 0 { // these are in the last column
            surroundingIndexes = [chosenIndex - 1,
                                       chosenIndex + 7,
                                       chosenIndex - 8,
                                       chosenIndex + 8,
                                       chosenIndex - 9,]
        } else {
            surroundingIndexes = [chosenIndex - 1,
                                       chosenIndex + 1,
                                       chosenIndex - 7,
                                       chosenIndex + 7,
                                       chosenIndex - 8,
                                       chosenIndex + 8,
                                       chosenIndex - 9,
                                       chosenIndex + 9 ]
        }
        
        return surroundingIndexes
    }
    
    init(createFieldContent: (Int) -> FieldContent) {
        fields = []
        
        for fieldIndex in 0..<MinesweeperConstants.allFieldsCount {
            let content = createFieldContent(fieldIndex)
            fields.append(Field(content: content, id: fieldIndex))
        }
    }
    
    struct Field: Identifiable {
        var isChecked = false
        var isMarked = false
        let content: FieldContent
        let id: Int
    }
}
