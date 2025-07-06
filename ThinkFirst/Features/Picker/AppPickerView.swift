import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

struct AppPickerView: View {
    @State private var selection = FamilyActivitySelection()
    @State private var showingPicker = false
    @AppStorage("blockedApps") private var blockedAppsData: Data = Data()
    
    init() {
        print("AppPickerView loaded!")
    }
    
    // Helper to decode/encode tokens
    private var blockedTokens: Set<ApplicationToken> {
        get {
            (try? JSONDecoder().decode(Set<ApplicationToken>.self, from: blockedAppsData)) ?? []
        }
        set {
            blockedAppsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    private func setBlockedTokens(_ tokens: Set<ApplicationToken>) {
        blockedAppsData = (try? JSONEncoder().encode(tokens)) ?? Data()
    }
    
    var body: some View {
        let hasBlockedApps = !blockedTokens.isEmpty
        
        VStack(spacing: 24) {
            Text("Blocked Apps")
                .font(.title2.bold())
            Button("Select Apps to Block") {
                AuthorizationCenter.shared.requestAuthorization { result in
                    switch result {
                    case .success:
                        print("Family Controls authorization granted")
                        showingPicker = true
                    case .failure(let error):
                        print("Family Controls authorization failed: \(error)")
                        // Optionally show an alert to the user
                    }
                }
            }
            .accessibilityLabel("Select apps to block")
            
            if !hasBlockedApps {
                Text("No apps blocked yet. Select apps above to block them.")
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(blockedTokens.count) App\(blockedTokens.count == 1 ? "" : "s") Blocked")
                        .font(.headline)
                    Text("For privacy, app names can't be shown. Your selections are saved and will be blocked.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .sheet(isPresented: $showingPicker) {
            NavigationStack {
                FamilyActivityPicker(selection: $selection)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Reset Selection") {
                                selection = FamilyActivitySelection()
                                setBlockedTokens([])
                                showingPicker = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingPicker = false
                            }
                        }
                    }
                    .onChange(of: selection) { oldValue, newValue in
                        let tokens = newValue.applicationTokens
                        if tokens.isEmpty {
                            setBlockedTokens([])
                            DelayGateManager.shared.updateShields(for: [])
                        } else {
                            let limitedTokens = Set(Array(tokens.prefix(3)))
                            setBlockedTokens(limitedTokens)
                            DelayGateManager.shared.updateShields(for: limitedTokens)
                        }
                    }
                    .onAppear {
                        // Restore the saved selection when the picker appears
                        if !blockedTokens.isEmpty {
                            // Cannot restore selection in FamilyActivityPicker due to API limitations
                        }
                    }
            }
        }
        .padding()
    }
}
