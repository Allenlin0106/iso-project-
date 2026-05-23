import AVFoundation
import SwiftUI

/// 包裝 AVSpeechSynthesizer，預設使用中文（zh-TW）語音，可調語速。
final class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    /// 語速：0.0 ~ 1.0 對應到 AVSpeechUtterance 的最小/最大速率。
    @Published var rate: Double {
        didSet { UserDefaults.standard.set(rate, forKey: "speechRate") }
    }

    /// 朗讀語言代碼，預設台灣中文。
    @Published var languageCode: String {
        didSet { UserDefaults.standard.set(languageCode, forKey: "speechLanguage") }
    }

    init() {
        let storedRate = UserDefaults.standard.object(forKey: "speechRate") as? Double
        self.rate = storedRate ?? 0.45
        self.languageCode = UserDefaults.standard.string(forKey: "speechLanguage") ?? "zh-TW"
        configureAudioSession()
    }

    /// 朗讀一段文字。空字串時忽略。
    func speak(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = mappedRate()
        utterance.pitchMultiplier = 1.0
        synthesizer.speak(utterance)
    }

    /// 朗讀整句：以空白接起多個詞。
    func speakSentence(_ words: [String]) {
        speak(words.joined(separator: " "))
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Private

    /// 將 0...1 的偏好對應到 AVSpeechUtterance 的合法速率範圍。
    private func mappedRate() -> Float {
        let minRate = AVSpeechUtteranceMinimumSpeechRate
        let maxRate = AVSpeechUtteranceMaximumSpeechRate
        return minRate + (maxRate - minRate) * Float(rate)
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("設定音訊工作階段失敗：\(error)")
        }
    }
}
