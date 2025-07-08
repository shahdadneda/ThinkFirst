import Foundation
import Combine
import ManagedSettings
import FamilyControls

class DelayGateManager: ObservableObject {
    static let shared = DelayGateManager()
    
    // Published property to notify when an app is intercepted
    @Published var interceptedBundleID: String? = nil
    
    private var subscriptions = Set<AnyCancellable>()
    private let store = ManagedSettingsStore()
    
    private init() {
        // Setup interception logic (stub for now)
        setupInterception()
    }
    
    private func setupInterception() {
        // TODO: Implement actual interception using ManagedSettings
        // For now, this is a stub to simulate interception
        // Example: Listen to changes in ManagedSettings or simulate for preview
    }
    
    // Call this when an app launch is intercepted
    func intercept(bundleID: String) {
        DispatchQueue.main.async {
            self.interceptedBundleID = bundleID
        }
    }
    
    // Call this to clear the intercepted state (e.g., after user acts)
    func clearInterception() {
        DispatchQueue.main.async {
            self.interceptedBundleID = nil
        }
    }
    
    // Log a block event to Core Data
    func logBlockEvent(bundleID: String, skipped: Bool) {
        print("🔄 logBlockEvent called with bundleID: \(bundleID), skipped: \(skipped)")
        let context = PersistenceController.shared.container.viewContext
        let blockEvent = BlockEvent(context: context, bundleID: bundleID, skipped: skipped)
        print("📝 Created BlockEvent: \(blockEvent)")
        do {
            try context.save()
            print("✅ Successfully saved BlockEvent to Core Data")
        } catch {
            print("❌ Failed to save BlockEvent: \(error)")
        }
    }
    
    // Mock updateShields for UI/UX development (no real blocking)
    func updateShields(for tokens: Set<ApplicationToken>) {
        print("[MOCK] Would update shields for tokens: \(tokens)")
        if tokens.isEmpty {
            print("[MOCK] Would remove all shields")
        } else {
            print("[MOCK] Would apply shields to: \(tokens)")
        }
    }
}
