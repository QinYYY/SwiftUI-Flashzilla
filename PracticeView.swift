//
//  PracticeView.swift
//  Flashzilla
//
//  Created by QinY on 10/9/2024.
//

import SwiftUI

struct PracticeView: View {
    
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    @State private var currentAmount1 = Angle.zero
    @State private var finalAmount1 = Angle.zero
    
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    @State private var timerCount = 0
    
    @Environment(\.scenePhase) var scenePhase
    
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        ScrollView {
            
            Section {
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        .onTapGesture(count: 2, perform: {
                            print("Double Tapped")
                        })
                    
                    Text("LongPressed")
                        .onLongPressGesture {
                            print("LongPressed")
                        }
                    
                    Text("LongPressed2")
                        .onLongPressGesture(minimumDuration: 2) {
                            print("LongPressed,minimum 2 second")
                        } onPressingChanged: { inProgress in
                            print("In proess:\(inProgress)")
                        }
                    
                    Text("Hello")
                        .scaleEffect(finalAmount + currentAmount)
                        .gesture(
                        MagnifyGesture()
                            .onChanged{ value in
                                currentAmount = value.magnification - 1
                            }
                            .onEnded({ value in
                                finalAmount += currentAmount
                                currentAmount = 0
                            })
                        )
                    
                    Text("Hello")
                        .rotationEffect(finalAmount1 + currentAmount1)
                        .gesture(
                            RotateGesture()
                                .onChanged { value in
                                    currentAmount1 = value.rotation
                                }
                                .onEnded { value in
                                    finalAmount1 += currentAmount1
                                    currentAmount1 = .zero
                            }
                        )
                }
                .padding(20)
                .background(.regularMaterial)
            }
            
            Section {
                
                let dragGesture = DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation {
                            offset = .zero
                            isDragging = false
                        }
                    }
                
                
                let pressGesture = LongPressGesture()
                    .onEnded { VALUE in
                        withAnimation {
                            isDragging = true
                        }
                    }
                
                let combined = pressGesture.sequenced(before: dragGesture)
                
                Circle()
                    .fill(.red)
                    .frame(width: 64,height: 64)
                    .scaleEffect(isDragging ? 1.5 : 1)
                    .offset(offset)
                    .gesture(combined)
                
            }
            
            Section {
                ZStack {
                    
                    Rectangle()
                        .fill(.brown)
                        .frame(width: 300,height: 300)
                        .onTapGesture {
                            print("Rectangle tapped")
                        }
                    
                    Circle()
                        .fill(.cyan)
                        .frame(width: 300,height: 300)
                        .onTapGesture {
                            print("circle tapped")
                        }
    //                    .allowsHitTesting(false)
                        .contentShape(.rect)
                    
                }
            }
            
            Section {
                VStack {
                    Text("hello")
                    Spacer().frame(height: 50)
                    Text("world")
                }
                .background(.mint)
                .contentShape(.rect)
                .onTapGesture {
                    print("vstack tapped")
                }
                
                
            }
            
            Section {
    //            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                let timer = Timer.publish(every: 1,tolerance: 0.5, on: .main, in: .common).autoconnect()
                
                Text("Timer")
                    .onReceive(timer, perform: { time in
                        
                        
                        if timerCount == 5 {
                            timer.upstream.connect().cancel()
                        }else {
                            print("The time is now \(time)")
                        }
                        timerCount += 1
                    })
                
                
            }
            
            Section {
                
                Text("ScenePhase")
                    .onChange(of: scenePhase) { oldValue, newValue in
                        if newValue == .active {
                            print("Active")
                        } else if newValue == .inactive {
                            print("Inactive")
                        }else if newValue == .background {
                            print("Background")
                        }
                    }
                
            }
            
            Section {
                HStack {
                    if differentiateWithoutColor {
                        Image(systemName: "checkmark.circle")
                    }
                    Text ("success")
                }
                .padding()
                .background(differentiateWithoutColor ? .black : .green)
                .foregroundColor(.white)
                .clipShape(.capsule)
            }
            
        }
          
    }
}

#Preview {
    PracticeView()
}
