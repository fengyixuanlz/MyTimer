//
//  a.swift
//  MyTimer
//
//  Created by sherryfeng on 5/27/26.
//

import SwiftUI

struct RippleCircle: View {
    @State private var animate = false
    let timerType: TimerType
    let isRunning: Bool
    private let lineWidth = 10.0

    var body: some View {
        ZStack {
            Circle()
                   .stroke(
                       timerType == .concentrate
                       ? Color.mainColor01
                       : Color.mainColor02,
                       lineWidth: lineWidth
                   )
            
            if isRunning {
                Circle()
                    .stroke(timerType == .concentrate ? Color.mainColor01.opacity(0.5) : Color.mainColor02.opacity(0.5), lineWidth: lineWidth)
                    .scaleEffect(animate ? 1.2 : 1.0)
                    .opacity(animate ? 0 : 1)
                    .animation(isRunning ?
                        .easeOut(duration: timerType == .concentrate ? 1.5 : 3)
                        .repeatForever(autoreverses: false)
                        : .default,
                        value: animate)
            }
        }
        .onChange(of: isRunning) { _, running in
            if running {
                animate = true
            } else {
                animate = false
            }
        }
    }
}
