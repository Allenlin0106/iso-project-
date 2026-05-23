import Foundation

/// 一個分類（如「食物」「情緒」），內含有序的圖卡清單。
struct TileCategory: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String
    var iconSymbol: String
    var tiles: [CommunicationTile]

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String,
        iconSymbol: String,
        tiles: [CommunicationTile] = []
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconSymbol = iconSymbol
        self.tiles = tiles
    }
}
