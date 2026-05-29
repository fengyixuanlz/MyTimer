//
//  ContentView.swift
//  MyTimer
//
//  Created by sherryfeng on 5/11/26.
//

import SwiftUI

struct ContentView: View {
    /// 集中timer
    @State private var concentrate_timerHandler: Timer?
    @State private var concentrateCount = 0 // もう走った時間 - 集中
    
    /// 休憩timer
    @State private var rest_timerHandler: Timer?
    @State var restCount = 0 // もう走った時間 - 休憩
    
    @State private var currentState = TimerType.concentrate
    
    @State var isShowAlert = false
    @State private var bgColor: Color = .mainColor02
    
    @State private var isConRunning = false
    @State private var isRestRunning = false
    
    @State private var selectedVersion = 1 // 0 は　開発　｜１はリリース版
    
    let middleCircleSize = 330.0 // 大きい丸の大きさ
    let smallCircleSize = 306.0 // 大きい丸の大きさ
    let horizontalPadding: CGFloat = 30 // padding
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ZStack {
                    LinearGradient(colors: [Color.mainColor01.opacity(0.25), Color.mainColor02.opacity(0.25)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    // 一番大きい丸の設定する
                    RippleCircle(timerType: currentState, isRunning:
                        currentState == .concentrate ? isConRunning
                            : isRestRunning)
                        .frame(width: middleCircleSize, height: middleCircleSize)
                        .padding(.top, 40)
                    
                    // 丸の中で内容の設定する
                    VStack {
                        switch currentState {
                        case TimerType.concentrate:
                            ConcentrateCircle(remainingTime: setTimerBySelectedVersion(currentState) - concentrateCount)
                        case TimerType.rest:
                            ResetCircle(remainingTime: setTimerBySelectedVersion(currentState) - restCount)
                        }
                    }
                }
                
                HStack {
                    Button {
                        isConRunning = true
                        
                        InitailRest()
                        
                        currentState = TimerType.concentrate
                        startConcentrateTimer()
                    } label: {
                        Image(.tomato)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        Text("集中")
                    }
                    .mainButtonStyle()
                    Spacer()
                    Button {
                        isRestRunning = true
                        
                        InitailCon()
                        
                        currentState = TimerType.rest
                        startRestTimer()
                    } label: {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.white)
                        Text("休憩")
                    }
                    .mainButtonStyle(color: Color.mainColor02)
                }
                .padding(.horizontal, horizontalPadding)
                
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.mainColor01)
                            Text("集中：")
                            if setTimerBySelectedVersion(.concentrate) >= 60 {
                                Text("\(setTimerBySelectedVersion(.concentrate) / 60)")
                                    .foregroundStyle(Color.mainColor01)
                                    .font(.title2)
                                Text("分")
                            } else {
                                Text("\(setTimerBySelectedVersion(.concentrate))")
                                    .foregroundStyle(Color.mainColor01)
                                    .font(.title2)
                                Text("秒")
                            }
                        }
                        Spacer()
                        HStack {
                            Text("休憩：")
                            if setTimerBySelectedVersion(.rest) >= 60 {
                                Text("\(setTimerBySelectedVersion(.rest) / 60)")
                                    .foregroundStyle(Color.mainColor02)
                                    .font(.title2)
                                Text("分")
                            } else {
                                Text("\(setTimerBySelectedVersion(.rest))")
                                    .foregroundStyle(Color.mainColor02)
                                    .font(.title2)
                                Text("秒")
                            }
                        }
                        Spacer()
                    }
                    Text("ボタンを押すとカウントダウンが始まります")
                        .foregroundColor(Color.fontColor01.opacity(0.5))
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, horizontalPadding - 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.bg)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.mainColor01, lineWidth: 1)
                )
                .padding(horizontalPadding)
            }
            .ignoresSafeArea()
            .alert("",
                   isPresented: $isShowAlert)
            {
                Button("OK") {}
            } message: {
                Text("\(currentState == .concentrate ? "お疲れさまでした！休憩しましょう" : "休憩終了です！次の集中を始めましょう")")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView(selectedVersion: $selectedVersion)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("26CM0128 封怡璇")
                        .frame(width: 200)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    func endTimer() {}
    
    func concentrateCountDownTimer() {
        concentrateCount += 1
        if setTimerBySelectedVersion(.concentrate) - concentrateCount == 0 {
            isShowAlert = true
        }
        
        if setTimerBySelectedVersion(.concentrate) - concentrateCount <= 0 {
            InitailCon()
        }
    }

    func startConcentrateTimer() {
        if let concentrate_timerHandler, concentrate_timerHandler.isValid == true {
            return
        }
        
        if setTimerBySelectedVersion(.concentrate) - concentrateCount <= 0 {
            concentrateCount = 0
        }
        
        // 一秒钟执行一次block
        concentrate_timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            Task {
                @MainActor in
                concentrateCountDownTimer()
            }
        })
    }

    func InitailRest() {
        rest_timerHandler?.invalidate()
        rest_timerHandler = nil
        restCount = 0
        isRestRunning = false
    }
    
    func InitailCon() {
        concentrate_timerHandler?.invalidate()
        concentrate_timerHandler = nil
        concentrateCount = 0
        isConRunning = false
    }

    func restCountDownTimer() {
        restCount += 1
        if setTimerBySelectedVersion(.rest) - restCount == 0 {
            isShowAlert = true
        }
        if setTimerBySelectedVersion(.rest) - restCount <= 0 {
            InitailRest()
        }
    }
    
    func startRestTimer() {
        if let th = rest_timerHandler {
            if th.isValid == true {
                return
            }
        }
        
        if setTimerBySelectedVersion(.rest) - restCount <= 0 {
            restCount = 0
        }
        
        // 一秒钟执行一次block
        rest_timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            Task {
                @MainActor in
                restCountDownTimer()
            }
        })
    }
    
    /// 開発版の中に、集中と休憩二つモードがあります
    /// リリース版の中に、集中と休憩二つモードがあります
    func setTimerBySelectedVersion(_ currentState: TimerType) -> Int {
        switch selectedVersion {
        case 0: // development
            return currentState == .concentrate ? (SetTimeForDefault.DevelopmentConTime.rawValue) : (SetTimeForDefault.DevelopmentRestTime.rawValue)
        default:
            return currentState == .concentrate ? (SetTimeForDefault.ProductionConTime.rawValue) : (SetTimeForDefault.ProductionRestTime.rawValue)
        }
    }
    
//    var alertMessageText: String {
//        let remainTime = setTimerBySelectedVersion(currentState)
//        
//        // もし時間が 60分 より大きい、分です、あるいは　秒です
//        if remainTime > 60 {
//            return "あと \(remainTime / 60) 分です"
//        } else {
//            return "あと \(remainTime) 秒です"
//        }
//    }
}

#Preview {
    ContentView()
}
