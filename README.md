# 輔助溝通系統 (AAC for iPad)

一個給 iPad 使用的**輔助溝通 App (AAC, Augmentative and Alternative Communication)**。
使用者點選圖卡組成句子，App 用中文語音「代替使用者說話」。適合無口語或表達困難的使用者
（自閉症、腦麻、中風、漸凍症等）與其照顧者。

以原生 **SwiftUI** 開發，內建中文（繁體 / 國語）語音朗讀，照顧者可自訂圖卡與分類。

## 主要功能

- **圖卡溝通板**：依分類顯示圖卡，點一下即朗讀該詞並加入上方句子列。
- **整句朗讀**：按 🔊 朗讀整句，⌫ 退一格，🗑 清除。
- **中文語音**：使用系統內建 `AVSpeechSynthesizer`（`zh-TW`），可在設定調整語速。
- **自訂**：編輯模式可新增/編輯/刪除圖卡與分類、選 SF Symbol 或從相簿選照片、調整顏色。
- **離線可用、資料持久化**：溝通板存成 JSON、照片存於 App Documents。

## 開發 / 執行

> 需要 macOS + **Xcode 16 以上**（專案使用 file-system synchronized groups）。

1. 在 Xcode 開啟 `AAC.xcodeproj`。
2. 選擇 iPad 模擬器（例如 iPad Pro 11"）或實機。
3. 按 ▶︎ Run。最低部署目標 iOS 16。

> 若用實機，請在 target 的 Signing & Capabilities 選擇你的開發團隊。

## 專案結構

```
AAC/
  AACApp.swift              App 進入點，注入 AACStore 與 SpeechManager
  Models/                   資料模型（CommunicationTile / TileCategory / AACBoard）
  Store/                    AACStore（讀寫、CRUD、照片）與 DefaultData（中文種子詞彙）
  Speech/SpeechManager.swift 中文語音朗讀
  Views/                    主畫面、句子列、分類側欄、圖卡格、編輯與設定畫面
  Support/Color+Hex.swift   顏色工具
  Resources/Assets.xcassets AppIcon / AccentColor
```

## 手動測試清單

- 選分類 → 點圖卡：聽到中文發音，且該詞出現在句子列。
- 句子列按 🔊：整句朗讀；⌫ 退一格；🗑 清除。
- 進入「編輯」：
  - 新增圖卡（選圖示或從相簿選照片、設顏色），儲存後出現在格子裡。
  - 「管理分類」可新增/編輯/刪除/排序分類。
- 設定：拖動語速並「試聽」；「重設為預設詞彙」可還原。
- 重啟 App：自訂的圖卡與分類仍保留。
- 邊界：空句子時 🔊 不會當機；橫／直向切換版面正常；靜音開關下仍能發聲。

## 後續可擴充（v1 未含）

- 注音／拼音文字鍵盤輸入。
- 掃描式 (switch scanning) 輔具輸入、眼動控制。
- 編輯模式 PIN 鎖（防止使用者誤改）。
- iCloud 同步、多使用者設定檔。
