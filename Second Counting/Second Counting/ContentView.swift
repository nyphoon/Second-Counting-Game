//
//  ContentView.swift
//  first
//
//  Created by nyphoon on 2020/7/29.
//  Copyright © 2020 nyphoon. All rights reserved.
//

import SwiftUI

var watch = StopWatch()
var host = GameHost()

struct ContentView: View {
    @State var score = host.score
    @State var round = host.round
    @State var target = host.target // centisecond
    @State var timeCount = watch.fromStart() // centisecond
    @State var isShowingResult = false
    @State var isTimerRunning = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    struct LabelModifier: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .foregroundColor(Color.white)
                .font(Font.custom("TamilSangamMN-Bold", size: 24))
        }
    }
    struct TimerModifier: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .foregroundColor(Color.yellow)
                .font(Font.custom("TamilSangamMN-Bold", size: 42))
        }
    }
    struct TrigerModifier: ViewModifier{
        func body(content: Content) -> some View{
            return content
                .font(Font.custom("TamilSangamMN-Bold", size: 32))
                .padding()
                .foregroundColor(Color.white)
                .background(Color(red: 170.0/255.0, green: 70.0/355.0, blue: 60.0/255.0))
                .cornerRadius(80)
                .padding(10)
        }
    }

    func updateGame(){
        round = host.round
        score = host.score
        target = host.target
        timeCount = watch.fromStart()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Round: \(round)").modifier(LabelModifier())
                Spacer()
                Text("Score: \(score)").modifier(LabelModifier())
                Spacer()
                Button(action: {
                    host.startOver()
                    self.updateGame()
                }){
                    Text("Start Over")
                        .modifier(LabelModifier())
                        .background(Color.green)
                        .cornerRadius(10)
                }
                Spacer()
            }.padding(10)
            Spacer()
            Text("Please count \(secondDisplay(target)) second(s)").modifier(LabelModifier())
            Spacer()
            Text("\(centisecondDisplay(timeCount))").modifier(TimerModifier()).onReceive(timer) {
                _ in if self.isTimerRunning == true{
                    self.timeCount = watch.fromStart()
                }
            }
            Spacer()
            Button(action: {
                self.timeCount = watch.fromStart()
                if self.isTimerRunning == true{
                    self.isTimerRunning = false
                    self.isShowingResult = true
                    watch.stop()
                }else{
                    self.isTimerRunning = true
                    self.isShowingResult = false
                    watch.start()
                }
            }){
                if isTimerRunning == true{
                    Text("Stop").modifier(TrigerModifier())
                }else{
                    Text("Start").modifier(TrigerModifier())
                }
            }
            .alert(isPresented: $isShowingResult){
                () -> Alert in
                host.evaluate(watch.toStop())
                return Alert(title: Text(host.result.title),
                             message: Text(host.result.message),
                                     dismissButton: .default(Text("Next Round")) {
                                        host.nextRound()
                                        watch.reset()
                                        self.updateGame()
                                     })
                }
            }
            .padding(.bottom, 100)
            .background(Color(red: 35.0/255.0, green: 50.0/255.0, blue: 70.0/255.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
