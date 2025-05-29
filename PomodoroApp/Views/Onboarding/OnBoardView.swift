import SwiftUI

struct OnBoardView: View {
    @StateObject var onBoardViewModel = OnBoardViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState


    

    
    var body: some View {
        
        let activeColor = colorScheme == .dark ? Color.white : Color.black
        
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    TabView(selection: $onBoardViewModel.currentIndex) {
                        ForEach(OnBoardModel.items.indices, id: \.self) { index in
                            let value = OnBoardModel.items[index]
                            SliderCard(model: value, imageHeight: geometry.size.height * 0.4)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    Spacer()

                    HStack(spacing: 8) {
                        ForEach(0...onBoardViewModel.totalPages(), id: \.self) { index in
                            IndicatorRectangle(isActive: index == onBoardViewModel.currentIndex)
                                .foregroundColor(index == onBoardViewModel.currentIndex ? activeColor : activeColor.opacity(0.3))

                                .onTapGesture {
                                    onBoardViewModel.currentIndex = index
                                }
                        }
                    }
                    .frame(height: 20)

                    Button(action: {
                        if onBoardViewModel.currentIndex < onBoardViewModel.totalPages() {
                            onBoardViewModel.currentIndex += 1
                        } else {
                            appState.markOnboardingSeen() // ✅ Doğrudan appState’i tetikle
                        }
                    }) {
                        Text(onBoardViewModel.currentIndex == onBoardViewModel.totalPages() ? "Get Started" : "Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .environmentObject(appState) // ✅ View’a appState ekle

                    .padding()
                }
                .onAppear {
                    onBoardViewModel.checkUserFirstTime()
                }
                .padding()
                // ⬇️ NavigationLink'i buraya taşıdık
                .background(
                 
                    NavigationLink(destination: WelcomeView()
                      .navigationBarHidden(true)
                        .ignoresSafeArea(),
                        isActive: $onBoardViewModel.isHomeRedirect
                    ) {
                        EmptyView()
                    }
                  .hidden() // gizli ama çalışır
                )
            }
        }
    }
}


#Preview {
    OnBoardView()
        .environmentObject(AppState())
        .onAppear {
            UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
        }
}
