import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            TabView {
                VStack {
                    AppPickerView()
                    Button("Test Delay Gate") {
                        DelayGateManager.shared.intercept(bundleID: "com.example.testapp")
                    }
                    .padding()
                }
                .tabItem {
                    Label("Apps", systemImage: "app.badge")
                }
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
            }
            // Overlay the DelayGateView on top of everything
            DelayGateView()
        }
    }
}

#Preview {
    MainTabView()
}