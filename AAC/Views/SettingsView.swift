import SwiftUI

/// 設定：語速調整、重設為預設詞彙。
struct SettingsView: View {
    @EnvironmentObject private var store: AACStore
    @EnvironmentObject private var speech: SpeechManager
    @Environment(\.dismiss) private var dismiss

    @State private var showingResetConfirm = false

    var body: some View {
        NavigationStack {
            Form {
                Section("語音") {
                    VStack(alignment: .leading) {
                        Text("語速")
                        Slider(value: $speech.rate, in: 0...1)
                        HStack {
                            Text("慢").font(.caption).foregroundColor(.secondary)
                            Spacer()
                            Text("快").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    Button {
                        speech.speak("這是語音測試")
                    } label: {
                        Label("試聽", systemImage: "speaker.wave.2.fill")
                    }
                }

                Section("資料") {
                    Button(role: .destructive) {
                        showingResetConfirm = true
                    } label: {
                        Label("重設為預設詞彙", systemImage: "arrow.counterclockwise")
                    }
                }

                Section {
                    Text("輔助溝通系統 — 點選圖卡組成句子並朗讀。長按右上角「編輯」可自訂圖卡與分類。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
            .confirmationDialog("確定要重設嗎？所有自訂的圖卡與分類將被清除。",
                                isPresented: $showingResetConfirm, titleVisibility: .visible) {
                Button("重設", role: .destructive) {
                    store.resetToDefaults()
                    dismiss()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }
}
