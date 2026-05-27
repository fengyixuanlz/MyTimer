//
//  SettingView.swift
//  MyTimer
//
//  Created by sherryfeng on 5/11/26.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("totalConcentrateTime") private var totalConcentrateTime = 25
    @AppStorage("totalRestTime") private var totalRestTime = 5
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.mainColor01.opacity(0.25), Color.mainColor02.opacity(0.25)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack {
                    Text("集中時間設定：\(totalConcentrateTime)分")
                        .font(.largeTitle)
                        .foregroundStyle(.mainColor01)
                    Picker(selection: $totalConcentrateTime) {
                        ForEach(20..<65) { index in
                            if index % 5 == 0 {
                                Text("\(index)")
                                    .tag(index)
                            }
                        }
                    } label: {
                        Text("選択してください")
                    }
                    .pickerStyle(.wheel)
                }
                .padding()
                .background(Color.bg)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Divider()
                Spacer()
                
                VStack {
                    Text("休憩時間設定：\(totalRestTime)分")
                        .font(.largeTitle)
                        .foregroundStyle(.mainColor02)
                    Picker(selection: $totalRestTime) {
                        ForEach(5..<25) { index in
                            if index % 5 == 0 {
                                Text("\(index)")
                                    .tag(index)
                            }
                        }
                    } label: {
                        Text("選択してください")
                    }
                    .pickerStyle(.wheel)
                }
                .padding()
                .background(Color.bgColor01)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                Divider()
            }
        }
    }
}

#Preview {
    SettingView()
}
