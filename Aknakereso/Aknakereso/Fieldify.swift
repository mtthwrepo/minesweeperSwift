//
//  Fieldify.swift
//  Aknakereso
//
//  Created by Laczkó Máté on 2023. 01. 08..
//

import SwiftUI

struct Fieldify: AnimatableModifier {
    var isChecked: Bool
    var isMarked: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = Rectangle()
            if isChecked {
                shape.fill().foregroundColor(.gray)
                shape.strokeBorder(lineWidth: 3)
            } else {
                shape.fill().foregroundColor(isMarked ? .red : .blue)
                shape.strokeBorder(lineWidth: 3)
            }
            content
                .opacity(isChecked ? 1 : 0)
        }
    }
}

extension View {
    func fieldify(isChecked: Bool, isMarked: Bool) -> some View {
        self.modifier(Fieldify(isChecked: isChecked, isMarked: isMarked))
    }
}
