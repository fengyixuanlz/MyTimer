//
//  SwiftUIView.swift
//  MyTimer
//
//  Created by sherryfeng on 5/11/26.
//

import SwiftUI

struct MainButtonModifier: ViewModifier {
    var backColor: Color = Color.mainColor01
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(Color.white)
            .frame(width: 160, height: 80)
            .background(backColor)
            .cornerRadius(16)
    }
}

extension View {
    func mainButtonStyle(color: Color) -> some View {
        self.modifier(MainButtonModifier(backColor: color))
    }
    func mainButtonStyle() -> some View {
        self.modifier(MainButtonModifier())
    }
}
