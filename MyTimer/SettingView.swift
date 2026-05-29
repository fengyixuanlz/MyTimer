//
//  SettingView.swift
//  MyTimer
//
//  Created by sherryfeng on 5/11/26.
//

import SwiftUI

struct SettingView: View {
    @Binding var selectedVersion: Int

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.mainColor01.opacity(0.25), Color.mainColor02.opacity(0.25)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("モード設定")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Picker("バージョン選択", selection: $selectedVersion) {
                    Text("🛠️ 開発版").tag(0)
                    Text("🚀 リリース").tag(1)
                }
                .scaleEffect(1.2)
                .pickerStyle(.segmented) // 变成好看的胶囊滑块样式
                .frame(height: 100)
                .padding(.horizontal, 30)

                HStack(spacing: 20) {
                    if selectedVersion == 0 {
                        // リリース
                        Label {
                            Text("集中: \(SetTimeForDefault.DevelopmentConTime.rawValue)秒")
                        } icon: {
                            Image("tomato")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        Label("休憩: \(SetTimeForDefault.DevelopmentRestTime.rawValue)秒", systemImage: "leaf.fill")
                    } else {
                        // 開発
                        Label {
                            Text("集中: \(SetTimeForDefault.ProductionConTime.rawValue / 60)分")
                        } icon: {
                            Image("tomato")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        Label("休憩: \(SetTimeForDefault.ProductionRestTime.rawValue / 60)分", systemImage: "leaf.fill")
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.8))
            .cornerRadius(12)
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var tempVersion = 0
    SettingView(selectedVersion: $tempVersion)
}
