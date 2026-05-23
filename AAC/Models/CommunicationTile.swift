import Foundation

/// 圖卡的圖示來源：內建 SF Symbol 或使用者從相簿選的照片（以檔名引用，存於 Documents）。
enum SymbolKind: Codable, Hashable {
    case sfSymbol(String)
    case photo(filename: String)
}

/// 單一溝通圖卡。`label` 為畫面顯示文字，`spokenText` 為朗讀文字（可不同，預設等於 label）。
struct CommunicationTile: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var label: String
    var spokenText: String
    var symbol: SymbolKind
    var colorHex: String

    init(
        id: UUID = UUID(),
        label: String,
        spokenText: String? = nil,
        symbol: SymbolKind,
        colorHex: String
    ) {
        self.id = id
        self.label = label
        self.spokenText = spokenText ?? label
        self.symbol = symbol
        self.colorHex = colorHex
    }
}
