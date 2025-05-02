//
//  OnBoardingView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 18.04.2025.
//

import SwiftUI

struct OnBoardView: View {
    @StateObject var onBoardViewModel = OnBoardViewModel()
    
    var body: some View {
        NavigationView{
            GeometryReader{
                geometry in
                VStack{
                    Spacer()
                    TabView(selection: $onBoardViewModel.currentIndex) {
                        ForEach(OnBoardModel.items.indices, id: \.self) {index in
                            let value = OnBoardModel.items[index]
                            SliderCard(model: value, imageHeight: geometry.size.height * 0.4)
                                .tag(index)
                            
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    Spacer()
                    
                    HStack(spacing: 8){
                        ForEach(0...onBoardViewModel.totalPages(), id: \.self) {
                            index in
                            IndicatorRectangle(isActive: index  == onBoardViewModel.currentIndex)
                        }
                    }
                    .frame(height: 20)
                    
                    NavigationLink(
                        isActive: $onBoardViewModel.isHomeRedirect
                    ) {
                        WelcomeView()
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                    } label: {
                        NormalButton(
                            onTap: {
                                onBoardViewModel.saveUserLoginAndRedirect()
                            }, title: onBoardViewModel.currentIndex == onBoardViewModel.totalPages() ? "Get Started" : "Next"
                        )
                    }
                    .padding()
                    
                }
                .onAppear {
                    onBoardViewModel.checkUserFirstTime()
                }
            }
        }
    }
}

#Preview {
    OnBoardView()
}
