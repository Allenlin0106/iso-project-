import SwiftUI

/// 顯示某分類底下所有圖卡的自適應格狀排列。
struct TileGridView: View {
    let category: TileCategory
    let isEditing: Bool
    let onTileTap: (CommunicationTile) -> Void
    let onTileEdit: (CommunicationTile) -> Void
    let onTileDelete: (CommunicationTile) -> Void
    let onAddTile: () -> Void

    private let columns = [GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 16)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(category.tiles) { tile in
                    ZStack(alignment: .topTrailing) {
                        TileButtonView(tile: tile) {
                            if isEditing {
                                onTileEdit(tile)
                            } else {
                                onTileTap(tile)
                            }
                        }

                        if isEditing {
                            Button {
                                onTileDelete(tile)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .background(Circle().fill(.white))
                            }
                            .buttonStyle(.plain)
                            .offset(x: 6, y: -6)
                        }
                    }
                }

                if isEditing {
                    Button(action: onAddTile) {
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 40))
                            Text("新增圖卡")
                                .font(.title3.weight(.semibold))
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 110)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                .foregroundColor(.secondary)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
    }
}
