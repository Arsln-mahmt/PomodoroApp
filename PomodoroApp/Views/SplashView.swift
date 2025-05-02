//
//  SplashScreen.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 18.04.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var rotate = false
    
    var body: some View {
        if isActive {
            OnBoardView()
        }else {
            VStack{
                Spacer()

                Image("SplashIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(Animation.linear(duration: 2.5).repeatForever(autoreverses: false), value: rotate)
                    .onAppear {
                        rotate = true
                    }

                Text("Pomodoro App")
                    .font(.system(size: 28,weight: .bold))
                    .padding(.top,20)
                
                Spacer()
                
                Text("Focus. Build. Win.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
