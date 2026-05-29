//
//  format.swift
//  MyTimer
//
//  Created by sherryfeng on 5/27/26.
//

import Foundation
struct Format {
    static func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60

        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

enum TimerType {
    case concentrate
    case rest
}

enum SetTimeForDefault: Int, Codable {
    case DevelopmentConTime = 5
    case DevelopmentRestTime = 3
    case ProductionConTime = 1500
    case ProductionRestTime = 300
}
