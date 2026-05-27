//
//  ConcentrateCircle.swift
//  MyTimer
//
//  Created by sherryfeng on 5/25/26.
//

import SwiftUI

struct ConcentrateCircle: View {
    let remainingTime: Int

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .foregroundStyle(Color.mainColor01)
            Text("集中モード")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.mainColor01)

            Text("\(Format.formatTime(remainingTime))")
                .font(.system(size: 77))
                .fontWeight(.bold)
                .foregroundColor(.fontColor01)
            Text("集中しています")
                .font(.title3)
                .foregroundColor(.mainColor01)
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
                .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.bg) // 1. 先用背景色填满这个圆角矩形
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.mainColor01, lineWidth: 1) // 2. 再给这个圆角矩形描个边
                            )
                    )
        }
    }
}

#Preview {
    ConcentrateCircle(remainingTime: 120)
}
