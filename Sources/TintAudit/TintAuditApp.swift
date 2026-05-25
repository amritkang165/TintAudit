import TokamakShim

// Entry point for the TintAudit WebAssembly application.
// Tokamak renders this SwiftUI-style tree into the browser DOM.
@main
struct TintAuditApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
