import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Show Delay Gate") {
                    DelayGateManager.shared.intercept(bundleID: "com.example.testapp")
                }
                .padding()
            }
            // Overlay the DelayGateView on top
            DelayGateView()
        }
    }
}

#Preview {
    ContentView()
}