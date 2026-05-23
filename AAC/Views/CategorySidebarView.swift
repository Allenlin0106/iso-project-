import SwiftUI

/// 左側分類側欄：點選切換目前顯示的分類。
struct CategorySidebarView: View {
    let categories: [TileCategory]
    @Binding var selectedID: UUID?

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(categories) { category in
                    Button {
                        selectedID = category.id
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: category.iconSymbol)
                                .font(.title3)
                                .frame(width: 32)
                            Text(category.name)
                                .font(.title3.weight(.semibold))
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(background(for: category))
                        .foregroundColor(foreground(for: category))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
        }
        .frame(width: 220)
        .background(Color(.systemBackground))
    }

    private func isSelected(_ category: TileCategory) -> Bool {
        category.id == selectedID
    }

    private func background(for category: TileCategory) -> Color {
        isSelected(category) ? Color(hex: category.colorHex) : Color(.secondarySystemBackground)
    }

    private func foreground(for category: TileCategory) -> Color {
        isSelected(category) ? Color(hex: category.colorHex).readableForeground() : .primary
    }
}
