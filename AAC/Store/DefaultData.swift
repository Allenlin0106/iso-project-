import Foundation

/// 首次啟動時的中文種子詞彙，全部使用 SF Symbols，不需照片即可使用。
enum DefaultData {
    static func makeBoard() -> AACBoard {
        AACBoard(categories: [
            TileCategory(
                name: "基本需求",
                colorHex: "#64B5F6",
                iconSymbol: "hand.raised.fill",
                tiles: [
                    CommunicationTile(label: "我", symbol: .sfSymbol("person.fill"), colorHex: "#64B5F6"),
                    CommunicationTile(label: "要", symbol: .sfSymbol("hand.point.up.left.fill"), colorHex: "#64B5F6"),
                    CommunicationTile(label: "不要", symbol: .sfSymbol("hand.raised.fill"), colorHex: "#E57373"),
                    CommunicationTile(label: "還要", symbol: .sfSymbol("plus.circle.fill"), colorHex: "#81C784"),
                    CommunicationTile(label: "停", symbol: .sfSymbol("stop.circle.fill"), colorHex: "#E57373"),
                    CommunicationTile(label: "幫忙", spokenText: "請幫忙", symbol: .sfSymbol("hands.sparkles.fill"), colorHex: "#FFB74D")
                ]
            ),
            TileCategory(
                name: "食物",
                colorHex: "#FFB74D",
                iconSymbol: "fork.knife",
                tiles: [
                    CommunicationTile(label: "吃", symbol: .sfSymbol("fork.knife"), colorHex: "#FFB74D"),
                    CommunicationTile(label: "喝", symbol: .sfSymbol("cup.and.saucer.fill"), colorHex: "#4FC3F7"),
                    CommunicationTile(label: "水", symbol: .sfSymbol("drop.fill"), colorHex: "#4FC3F7"),
                    CommunicationTile(label: "飯", symbol: .sfSymbol("takeoutbag.and.cup.and.straw.fill"), colorHex: "#FFD54F"),
                    CommunicationTile(label: "餓了", spokenText: "我餓了", symbol: .sfSymbol("face.smiling"), colorHex: "#FF8A65"),
                    CommunicationTile(label: "水果", symbol: .sfSymbol("carrot.fill"), colorHex: "#81C784")
                ]
            ),
            TileCategory(
                name: "情緒",
                colorHex: "#BA68C8",
                iconSymbol: "heart.fill",
                tiles: [
                    CommunicationTile(label: "開心", symbol: .sfSymbol("face.smiling.fill"), colorHex: "#FFD54F"),
                    CommunicationTile(label: "難過", symbol: .sfSymbol("cloud.rain.fill"), colorHex: "#7986CB"),
                    CommunicationTile(label: "生氣", symbol: .sfSymbol("flame.fill"), colorHex: "#E57373"),
                    CommunicationTile(label: "累", spokenText: "我很累", symbol: .sfSymbol("zzz"), colorHex: "#90A4AE"),
                    CommunicationTile(label: "痛", spokenText: "會痛", symbol: .sfSymbol("bandage.fill"), colorHex: "#F06292"),
                    CommunicationTile(label: "害怕", symbol: .sfSymbol("exclamationmark.triangle.fill"), colorHex: "#9575CD")
                ]
            ),
            TileCategory(
                name: "人物",
                colorHex: "#4DB6AC",
                iconSymbol: "person.2.fill",
                tiles: [
                    CommunicationTile(label: "媽媽", symbol: .sfSymbol("figure.dress"), colorHex: "#F06292"),
                    CommunicationTile(label: "爸爸", symbol: .sfSymbol("figure.stand"), colorHex: "#64B5F6"),
                    CommunicationTile(label: "老師", symbol: .sfSymbol("graduationcap.fill"), colorHex: "#9575CD"),
                    CommunicationTile(label: "朋友", symbol: .sfSymbol("person.2.fill"), colorHex: "#4DB6AC"),
                    CommunicationTile(label: "醫生", symbol: .sfSymbol("cross.case.fill"), colorHex: "#E57373")
                ]
            ),
            TileCategory(
                name: "活動",
                colorHex: "#81C784",
                iconSymbol: "figure.run",
                tiles: [
                    CommunicationTile(label: "玩", symbol: .sfSymbol("gamecontroller.fill"), colorHex: "#81C784"),
                    CommunicationTile(label: "睡覺", symbol: .sfSymbol("bed.double.fill"), colorHex: "#7986CB"),
                    CommunicationTile(label: "上廁所", symbol: .sfSymbol("toilet.fill"), colorHex: "#4FC3F7"),
                    CommunicationTile(label: "出去", spokenText: "我要出去", symbol: .sfSymbol("figure.walk"), colorHex: "#AED581"),
                    CommunicationTile(label: "看書", symbol: .sfSymbol("book.fill"), colorHex: "#FFB74D"),
                    CommunicationTile(label: "聽音樂", symbol: .sfSymbol("music.note"), colorHex: "#BA68C8")
                ]
            ),
            TileCategory(
                name: "回應",
                colorHex: "#AED581",
                iconSymbol: "checkmark.circle.fill",
                tiles: [
                    CommunicationTile(label: "好", symbol: .sfSymbol("checkmark.circle.fill"), colorHex: "#81C784"),
                    CommunicationTile(label: "謝謝", symbol: .sfSymbol("hands.clap.fill"), colorHex: "#FFD54F"),
                    CommunicationTile(label: "對", symbol: .sfSymbol("hand.thumbsup.fill"), colorHex: "#81C784"),
                    CommunicationTile(label: "錯", symbol: .sfSymbol("hand.thumbsdown.fill"), colorHex: "#E57373"),
                    CommunicationTile(label: "再見", symbol: .sfSymbol("hand.wave.fill"), colorHex: "#4FC3F7")
                ]
            )
        ])
    }
}
