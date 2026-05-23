import SwiftUI

/// 管理分類：新增、編輯名稱/圖示/顏色、刪除、排序。
struct CategoryEditView: View {
    @EnvironmentObject private var store: AACStore
    @Environment(\.dismiss) private var dismiss

    @State private var editingCategory: TileCategory?
    @State private var showingNew = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.board.categories) { category in
                    Button {
                        editingCategory = category
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: category.iconSymbol)
                                .foregroundColor(Color(hex: category.colorHex).readableForeground())
                                .frame(width: 36, height: 36)
                                .background(Color(hex: category.colorHex))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(category.name)
                                .font(.body.weight(.medium))
                            Spacer()
                            Text("\(category.tiles.count) 張")
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .onDelete { offsets in
                    for index in offsets {
                        store.deleteCategory(id: store.board.categories[index].id)
                    }
                }
                .onMove { source, destination in
                    store.moveCategories(from: source, to: destination)
                }
            }
            .navigationTitle("管理分類")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("完成") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNew = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(item: $editingCategory) { category in
                CategoryFormView(existing: category)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingNew) {
                CategoryFormView(existing: nil)
                    .environmentObject(store)
            }
        }
    }
}

/// 新增/編輯單一分類的表單。
private struct CategoryFormView: View {
    let existing: TileCategory?

    @EnvironmentObject private var store: AACStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var colorHex: String
    @State private var iconSymbol: String

    private let iconChoices = [
        "hand.raised.fill", "fork.knife", "heart.fill", "person.2.fill",
        "figure.run", "checkmark.circle.fill", "house.fill", "book.fill",
        "gamecontroller.fill", "cart.fill", "cross.case.fill", "star.fill",
        "sun.max.fill", "moon.fill", "music.note", "car.fill"
    ]

    init(existing: TileCategory?) {
        self.existing = existing
        _name = State(initialValue: existing?.name ?? "")
        _colorHex = State(initialValue: existing?.colorHex ?? TilePalette.colors[5])
        _iconSymbol = State(initialValue: existing?.iconSymbol ?? "star.fill")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("名稱") {
                    TextField("分類名稱", text: $name)
                }
                Section("圖示") {
                    let columns = [GridItem(.adaptive(minimum: 56), spacing: 12)]
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(iconChoices, id: \.self) { name in
                            Image(systemName: name)
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .background(iconSymbol == name ? Color(hex: colorHex) : Color(.secondarySystemBackground))
                                .foregroundColor(iconSymbol == name ? Color(hex: colorHex).readableForeground() : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture { iconSymbol = name }
                        }
                    }
                    .padding(.vertical, 4)
                }
                Section("顏色") {
                    let columns = [GridItem(.adaptive(minimum: 44), spacing: 12)]
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(TilePalette.colors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.primary, lineWidth: colorHex == hex ? 3 : 0))
                                .onTapGesture { colorHex = hex }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(existing == nil ? "新增分類" : "編輯分類")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let existing {
            var updated = existing
            updated.name = trimmed
            updated.colorHex = colorHex
            updated.iconSymbol = iconSymbol
            store.updateCategory(updated)
        } else {
            store.addCategory(TileCategory(name: trimmed, colorHex: colorHex, iconSymbol: iconSymbol))
        }
        dismiss()
    }
}
