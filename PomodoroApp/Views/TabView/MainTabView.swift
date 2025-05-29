import SwiftUI

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var viewModel = MainViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(viewModel: viewModel)
                .tag(0)
                .tabItem {
                    Label("Goals", systemImage: "list.bullet")
                }

            SettingsView()
                .tag(1)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}


#Preview {
    MainTabView()
}
