import Foundation

/// 整體溝通板的根容器，為序列化單位（存成 board.json）。
struct AACBoard: Codable {
    var categories: [TileCategory]

    init(categories: [TileCategory] = []) {
        self.categories = categories
    }
}
