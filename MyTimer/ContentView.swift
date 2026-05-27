//
//  ContentView.swift
//  MyTimer
//
//  Created by sherryfeng on 5/11/26.
//

import SwiftUI

struct ContentView: View {
    // 集中timer
    @State private var concentrate_timerHandler: Timer?
    var totalConcentrateTime = 1500 // UserDefaults
    @State private var concentrateCount = 0 // もう走った時間 - 集中
    
    // 休憩timer
    @State private var rest_timerHandler: Timer?
    var totalRestTime = 300 // UserDefaults
    @State var restCount = 0 // もう走った時間 - 休憩
    
    @State private var currentState = TimerType.concentrate
    
    @State var isShowAlert = false
    @State private var bgColor: Color = .mainColor02
    
    @State private var isConRunning = false
    @State private var isRestRunning = false
    
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
                    
                    // 丸の中で内容の設定する
                    VStack {
                        switch currentState {
                        case TimerType.concentrate:
                            ConcentrateCircle(remainingTime: totalConcentrateTime - concentrateCount)
                        case TimerType.rest:
                            ResetCircle(remainingTime: totalRestTime - restCount)
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
                        Image(systemName: "clock.fill")
                            .foregroundColor(.white)
                        Text("集中")
                            .alert("まもなく終了します",
                                   isPresented: $isShowAlert)
                            {
                                Button("OK") {}
                            } message: {
                                Text("あと5秒です")
                            }
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
                            Text("集中：")
                            if totalConcentrateTime>=60 {
                                Text("\(totalConcentrateTime / 60)")
                                    .foregroundStyle(Color.mainColor01)
                                    .font(.title2)
                                Text("分")
                            } else {
                                Text("\(totalConcentrateTime)")
                                    .foregroundStyle(Color.mainColor01)
                                    .font(.title2)
                                Text("秒")
                            }
                        }
                        Spacer()
                        HStack {
                            Text("休憩：")
                            if totalRestTime>=60 {
                                Text("\(totalRestTime / 60)")
                                    .foregroundStyle(Color.mainColor02)
                                    .font(.title2)
                                Text("分")
                            } else {
                                Text("\(totalRestTime)")
                                    .foregroundStyle(Color.mainColor02)
                                    .font(.title2)
                                Text("秒")
                            }
                        }
                        Spacer()
                    }
                    Text("ボタンを押すとカウントダウンが始まります")
                        .foregroundColor(Color.fontColor01)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Label("時間設定", systemImage: "slider.horizontal.3")
                    }
                }
            }
        }
    }

    func endTimer() {}
    
    func concentrateCountDownTimer() {
        concentrateCount += 1
        if totalConcentrateTime - concentrateCount == 5 {
            isShowAlert = true
        }
        
        if totalConcentrateTime - concentrateCount <= 0 {
            InitailCon()
        }
    }

    func startConcentrateTimer() {
        if let concentrate_timerHandler, concentrate_timerHandler.isValid == true {
            return
        }
        
        if totalConcentrateTime - concentrateCount <= 0 {
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
        if totalRestTime - restCount == 5 {
            isShowAlert = true
        }
        if totalRestTime - restCount <= 0 {
            InitailRest()
        }
    }
    
    func startRestTimer() {
        if let th = rest_timerHandler { // 它在检查：timerHandler 里现在有定时器对象吗？
            if th.isValid == true { // 检查这个定时器是否正在运行（isValid）
                return
            }
        }
        
        if totalRestTime - restCount <= 0 {
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
}

#Preview {
    ContentView()
}
