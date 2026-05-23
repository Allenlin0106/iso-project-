import SwiftUI

@main
struct AACApp: App {
    @StateObject private var store = AACStore()
    @StateObject private var speech = SpeechManager()

    var body: some Scene {
        WindowGroup {
            CommunicationView()
                .environmentObject(store)
                .environmentObject(speech)
        }
    }
}
