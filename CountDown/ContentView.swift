//
//  ContentView.swift
//  CountDown
//
//  Created by 刘克 on 2023/1/7.
//

import SwiftUI

struct ContentView: View {
    @State var totalCountdown: CGFloat = 30
    @State var counter: Int = 0
    @State var isStart = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var inputCountdown = ""
    
    var body: some View {
        VStack {
            titleView()
            Spacer()
            ZStack {
                progressTrackView()
                progressBarView()
                progressTimeView()
            }
            Spacer()
            inputView()
            btnView()
                
        }
        .onReceive(timer) { time in
            self.startCounting()
        }
        .background(.green)
    }
    
    func titleView() -> some View {
        HStack {
            Text("计时器")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    func progressTrackView() -> some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(Circle().stroke(Color.black.opacity(0.09), lineWidth: 15))
    }
    
    func startProgress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(totalCountdown))
    }
    
    func completed() -> Bool {
        return startProgress() == 1
    }
    
    func progressBarView() -> some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 250, height: 250)
            .overlay(
                Circle()
                    .trim(from: 0, to: startProgress())
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .foregroundColor(
                        withAnimation(.easeInOut(duration: 0.2)){
                            completed() ? Color.green : Color.orange
                        }
                    )
            )
    }
    
    func counterToMinutes() -> String {
        let currentTime = Int(totalCountdown) - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
    func progressTimeView() -> some View{
        Text(counterToMinutes())
            .font(.system(size:48))
            .fontWeight(.black)
    }
    
    func inputView() -> some View {
        HStack {
            TextField("输入倒计时时间", text: $inputCountdown)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)
            Button("开始计时", action: {
                if let total = Int(self.inputCountdown) {
                    self.totalCountdown = CGFloat(total)
                    self.counter = 0
                    self.isStart = true
                }
            })
        }.padding(.vertical)
    }
    
    func btnView () -> some View{
        HStack(spacing: 55){
            Image(systemName: self.isStart ? "pause.fill" : "play.fill")
                .font(.system(size:40))
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: 80,minHeight: 0, maxHeight: 80)
                .background(self.isStart ? .red: .green)
                .clipShape(Capsule())
                .onTapGesture{
                    self.isStart.toggle()
                }
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: 80,minHeight: 0, maxHeight: 80)
                .background(.blue)
                .clipShape(Capsule())
                .onTapGesture{
                    self.counter = 0
                    withAnimation(.default){
                        self.totalCountdown = 30
                    }
                }
                .padding()
        }
    }
    
    func startCounting() {
        if self.isStart{
            if (self.counter < Int(self.totalCountdown)){
                self.counter += 1
                
            } else {
                self.isStart.toggle()
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
