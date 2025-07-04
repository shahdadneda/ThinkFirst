import SwiftUI

struct DelayGateView: View {
    @ObservedObject var manager = DelayGateManager.shared
    @AppStorage("delaySeconds") private var delaySeconds: Int = 5 // Default 5, range 1-10
    @State private var remaining: Int = 5
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        if let bundleID = manager.interceptedBundleID {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    Text("Think First")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .accessibilityLabel("Think First prompt")
                    ProgressRing(progress: progress)
                        .frame(width: 120, height: 120)
                        .padding()
                    Text("Opening \(bundleID) in \(remaining)s…")
                        .foregroundColor(.white)
                        .font(.title2)
                        .accessibilityLabel("Countdown: \(remaining) seconds left")
                    HStack(spacing: 24) {
                        Button(action: {
                            cancel()
                        }) {
                            Text("Skip")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Skip and cancel app launch")
                        Button(action: {
                            openAnyway()
                        }) {
                            Text("Open Anyway")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                        .accessibilityLabel("Open app anyway")
                    }
                }
            }
            .onAppear {
                startCountdown()
            }
            .onDisappear {
                stopCountdown()
            }
        }
    }
    
    private var progress: Double {
        1.0 - Double(remaining) / Double(delaySeconds)
    }
    
    private func startCountdown() {
        remaining = delaySeconds
        timerActive = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remaining > 1 {
                remaining -= 1
                // TODO: Trigger haptic pulse here
                DelayHaptics.pulseOnce()
            } else {
                openAnyway()
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        timerActive = false
    }
    
    private func cancel() {
        stopCountdown()
        manager.clearInterception()
    }
    
    private func openAnyway() {
        stopCountdown()
        // TODO: Actually open the app (requires system API)
        manager.clearInterception()
    }
}

struct ProgressRing: View {
    var progress: Double // 0.0 to 1.0
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
    }
}
