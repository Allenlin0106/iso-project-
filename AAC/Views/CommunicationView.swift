import SwiftUI

/// 主畫面：句子列 + 分類側欄 + 圖卡格。
struct CommunicationView: View {
    @EnvironmentObject private var store: AACStore
    @EnvironmentObject private var speech: SpeechManager

    @State private var selectedCategoryID: UUID?
    @State private var sentence: [CommunicationTile] = []
    @State private var isEditing = false

    @State private var editingTile: TileEditTarget?
    @State private var showingCategoryManager = false
    @State private var showingSettings = false

    private var selectedCategory: TileCategory? {
        store.board.categories.first { $0.id == selectedCategoryID }
            ?? store.board.categories.first
    }

    var body: some View {
        VStack(spacing: 0) {
            SentenceBarView(
                tiles: sentence,
                onSpeak: speakSentence,
                onBackspace: { if !sentence.isEmpty { sentence.removeLast() } },
                onClear: { sentence.removeAll() },
                onTapTile: { index in speech.speak(sentence[index].spokenText) }
            )

            toolbar

            Divider()

            HStack(spacing: 0) {
                CategorySidebarView(
                    categories: store.board.categories,
                    selectedID: Binding(
                        get: { selectedCategory?.id },
                        set: { selectedCategoryID = $0 }
                    )
                )

                Divider()

                if let category = selectedCategory {
                    TileGridView(
                        category: category,
                        isEditing: isEditing,
                        onTileTap: handleTileTap,
                        onTileEdit: { tile in editingTile = TileEditTarget(categoryID: category.id, tile: tile) },
                        onTileDelete: { tile in store.deleteTile(id: tile.id, fromCategory: category.id) },
                        onAddTile: { editingTile = TileEditTarget(categoryID: category.id, tile: nil) }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    emptyState
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $editingTile) { target in
            EditTileView(categoryID: target.categoryID, existingTile: target.tile)
                .environmentObject(store)
        }
        .sheet(isPresented: $showingCategoryManager) {
            CategoryEditView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(store)
                .environmentObject(speech)
        }
    }

    // MARK: - 子視圖

    private var toolbar: some View {
        HStack(spacing: 16) {
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
            }

            Spacer()

            if isEditing {
                Button {
                    showingCategoryManager = true
                } label: {
                    Label("管理分類", systemImage: "square.grid.2x2")
                        .font(.headline)
                }
            }

            Button {
                withAnimation { isEditing.toggle() }
            } label: {
                Label(isEditing ? "完成" : "編輯", systemImage: isEditing ? "checkmark" : "pencil")
                    .font(.headline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(isEditing ? Color.green.opacity(0.2) : Color.blue.opacity(0.15))
                    .foregroundColor(isEditing ? .green : .blue)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("還沒有分類，進入編輯模式新增一個吧。")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - 動作

    private func handleTileTap(_ tile: CommunicationTile) {
        speech.speak(tile.spokenText)
        sentence.append(tile)
    }

    private func speakSentence() {
        speech.speakSentence(sentence.map { $0.spokenText })
    }
}

/// 用來驅動編輯/新增圖卡 sheet 的目標。
struct TileEditTarget: Identifiable {
    let id = UUID()
    let categoryID: UUID
    let tile: CommunicationTile?
}
