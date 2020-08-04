//
//  ContentView.swift
//  first
//
//  Created by nyphoon on 2020/7/29.
//  Copyright © 2020 nyphoon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingResult = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timeCount = 0.0
    @State var isTimerRunning = false
    @State var target = Int.random(in: 1...5)
    @State var round = 0
    @State var score = 0
    @State var currentScore = 0
    
    func newRound(){
        timeCount = 0.0
        target = Int.random(in: 1...5)
        round += 1
        score += currentScore
        currentScore = 0
    }
    func getActionPrompt() -> String{
        let prompt: String
        if isTimerRunning == true{
            prompt = "Stop"
        }else{
            prompt = "Start"
        }
        return prompt
    }
    func timeCountString() -> String {
        String(format: "%.1f", timeCount)
    }
    func evaluateScore() -> Int {
        let diff = abs(timeCount - Double(target))
        let score: Int
        if diff == 0.0 {
            score = 5
        }else if diff <= 1.0 {
            score = 2
        }else if diff <= 2.0 {
            score = 1
        }else{
            score = 0
        }
        print("diff \(diff) score \(score)")
        return score
    }
    func getAlertTitle() -> String {
        let title: String
        if currentScore == 1{
            title = "Not bad"
        }else if currentScore == 2{
            title = "Almost"
        }else if currentScore == 5{
            title = "Awesome! Just hit it"
        }else{
            title = "Too far from target"
        }
        return title
    }
    func getAlertMessage() -> String {
        let resultTime = timeCountString()
        return "You stopped at \(resultTime) and got \(currentScore) point(s)"
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Round: \(round)")
                Spacer()
                Text("Score: \(score)")
                Spacer()
                Button(action: {
                    self.newRound()
                    self.round = 0
                    self.score = 0
                }){
                    Text("Start Over")
                }
                Spacer()
            }
            Spacer()
            Text("Please count \(target) second(s)")
            Spacer()
            Text("\(timeCountString())").onReceive(timer) {
                _ in if self.isTimerRunning == true{
                    self.timeCount += 0.1
                }
            }
            Spacer()
            Button(action: {
                if self.isTimerRunning == true{
                    self.isTimerRunning = false
                    self.currentScore = self.evaluateScore()
                    self.isShowingResult = true
                }else{
                    self.isTimerRunning = true
                    self.isShowingResult = false
                }
            }){
                Text(self.getActionPrompt())
            }
            .padding(.bottom, 100)

            .alert(isPresented: $isShowingResult){
                () -> Alert in
                return Alert(title: Text(getAlertTitle()),
                             message: Text(getAlertMessage()),
                             dismissButton: .default(Text("ok")) {
                                self.newRound()
                             })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}