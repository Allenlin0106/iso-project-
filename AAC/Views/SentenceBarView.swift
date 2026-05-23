import SwiftUI

/// 上方句子列：顯示已選圖卡，並提供朗讀 / 退一格 / 清除。
struct SentenceBarView: View {
    let tiles: [CommunicationTile]
    let onSpeak: () -> Void
    let onBackspace: () -> Void
    let onClear: () -> Void
    let onTapTile: (Int) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if tiles.isEmpty {
                            Text("點選下方圖卡來組成句子…")
                                .foregroundColor(.secondary)
                                .font(.title3)
                                .padding(.horizontal, 8)
                        } else {
                            ForEach(Array(tiles.enumerated()), id: \.offset) { index, tile in
                                Button {
                                    onTapTile(index)
                                } label: {
                                    HStack(spacing: 6) {
                                        symbolIcon(for: tile)
                                        Text(tile.label)
                                            .font(.title3.weight(.semibold))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: tile.colorHex))
                                    .foregroundColor(Color(hex: tile.colorHex).readableForeground())
                                    .clipShape(Capsule())
                                    .id(index)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: tiles.count) { _ in
                    if let last = tiles.indices.last {
                        withAnimation { proxy.scrollTo(last, anchor: .trailing) }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 64)
            .padding(.horizontal, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            controlButton(system: "speaker.wave.2.fill", tint: .blue, action: onSpeak)
                .disabled(tiles.isEmpty)
            controlButton(system: "delete.left.fill", tint: .orange, action: onBackspace)
                .disabled(tiles.isEmpty)
            controlButton(system: "trash.fill", tint: .red, action: onClear)
                .disabled(tiles.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    @ViewBuilder
    private func symbolIcon(for tile: CommunicationTile) -> some View {
        if case .sfSymbol(let name) = tile.symbol {
            Image(systemName: name)
        } else {
            Image(systemName: "photo")
        }
    }

    private func controlButton(system: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.title2)
                .frame(width: 56, height: 56)
                .background(tint.opacity(0.15))
                .foregroundColor(tint)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
