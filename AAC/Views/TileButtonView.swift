import SwiftUI
import UIKit

/// 單一溝通圖卡：圖示/照片 + 文字 + 顏色。大觸控目標，適合 iPad。
struct TileButtonView: View {
    let tile: CommunicationTile
    let action: () -> Void

    @EnvironmentObject private var store: AACStore

    private var background: Color { Color(hex: tile.colorHex) }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                symbolView
                    .frame(maxWidth: .infinity)
                Text(tile.label)
                    .font(.title3.weight(.semibold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.center)
                    .foregroundColor(background.readableForeground())
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tile.label)
    }

    @ViewBuilder
    private var symbolView: some View {
        switch tile.symbol {
        case .sfSymbol(let name):
            Image(systemName: name)
                .font(.system(size: 40))
                .foregroundColor(background.readableForeground())
        case .photo(let filename):
            if let image = store.loadPhoto(filename: filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(background.readableForeground())
            }
        }
    }
}
