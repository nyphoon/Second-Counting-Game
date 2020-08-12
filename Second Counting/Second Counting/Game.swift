//
//  Game.swift
//  Second Counting
//
//  Created by nyphoon on 2020/8/11.
//  Copyright © 2020 nyphoon. All rights reserved.
//

import SwiftUI // use Date, TimeInterval

func centisecondDisplay(_ centisecond: Int) -> String {
    String(format: "%d.%02d", centisecond/100, centisecond%100)
}

func secondDisplay(_ centisecond: Int) -> String {
    String(format: "%d", centisecond/100)
}

struct GameResult{
    let title: String
    let message: String
    let score: Int
    init(_ title: String, _ message: String, _ score: Int){
        self.title = title
        self.message = message
        self.score = score
    }
}

struct GameHost{
    var round = 0
    var score = 0
    var target = 0 // in centisecond
    var result = GameResult("", "", 0)

    init(){
        nextRound()
    }
    mutating func nextRound(){
        round += 1
        score += result.score
        target = Int.random(in: 1...5)
        target *= 100
    }
    mutating func startOver(){
        round = 0
        score = 0
        target = Int.random(in: 1...5)
        target *= 100
    }
    mutating func evaluate(_ answer: Int){
        let diff = abs(answer-target)
        if diff == 0{
            result = GameResult("Awesome!",
                                "You are right on the target \(secondDisplay(target)) second(s)",
                                10)
        }else if diff <= 50{
            result = GameResult("Almost",
                                "You stoped at \(centisecondDisplay(answer)) and \(centisecondDisplay(diff)) to go.",
                                5)
        }else if diff <= 100{
            result = GameResult("Good",
                                "You stoped at \(centisecondDisplay(answer)) and missed for \(centisecondDisplay(diff)). Keep going",
                                2)
        }else if diff <= 200{
            result = GameResult("OK",
                                "You stoped at \(centisecondDisplay(answer)) and missed for \(centisecondDisplay(diff)). You can make it.",
                                1)
        }else{
            result = GameResult("Poor",
                                "You stoped at \(centisecondDisplay(answer)) and missed for \(centisecondDisplay(diff)). Try gain.",
                                0)
        }
    }
}

struct StopWatch{
    private var timeStart: TimeInterval?
    private var timeStop: TimeInterval?

    mutating func start(){
        timeStart = Date().timeIntervalSince1970
    }
    mutating func stop(){
        timeStop = Date().timeIntervalSince1970
    }
    mutating func reset(){
        timeStart = nil
        timeStop = nil
    }
    func fromStart() -> Int{
        if timeStart == nil{
            return 0
        }
        let now = Date().timeIntervalSince1970
        let passed = Double(now) - Double(timeStart ?? now)
        return toCentisecond(passed)
    }
    func toStop() -> Int{
        if timeStop == nil{
            return 0
        }
        let diff = Double(timeStop ?? 0.0) - Double(timeStart ?? 0.0)
        return toCentisecond(diff)
    }
    private func toCentisecond(_ t: TimeInterval) -> Int{
        let d = Double(t*100).rounded()
        return Int(d)
    }
}

struct Game_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
