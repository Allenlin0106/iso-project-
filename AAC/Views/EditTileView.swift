import SwiftUI
import PhotosUI
import UIKit

/// 新增或編輯圖卡：文字、朗讀文字、顏色、SF Symbol 或從相簿選照片。
struct EditTileView: View {
    let categoryID: UUID
    /// 若為 nil 代表新增；否則為編輯既有圖卡。
    let existingTile: CommunicationTile?

    @EnvironmentObject private var store: AACStore
    @Environment(\.dismiss) private var dismiss

    @State private var label: String
    @State private var spokenText: String
    @State private var colorHex: String
    @State private var symbolName: String
    @State private var photoFilename: String?
    @State private var usesPhoto: Bool
    @State private var photoItem: PhotosPickerItem?

    private let symbolChoices = [
        "star.fill", "heart.fill", "hand.thumbsup.fill", "hand.raised.fill",
        "fork.knife", "cup.and.saucer.fill", "drop.fill", "house.fill",
        "bed.double.fill", "gamecontroller.fill", "book.fill", "music.note",
        "person.fill", "person.2.fill", "figure.walk", "car.fill",
        "sun.max.fill", "moon.fill", "cloud.rain.fill", "leaf.fill",
        "checkmark.circle.fill", "xmark.circle.fill", "plus.circle.fill", "questionmark.circle.fill"
    ]

    init(categoryID: UUID, existingTile: CommunicationTile?) {
        self.categoryID = categoryID
        self.existingTile = existingTile
        _label = State(initialValue: existingTile?.label ?? "")
        _spokenText = State(initialValue: existingTile?.spokenText ?? "")
        _colorHex = State(initialValue: existingTile?.colorHex ?? TilePalette.colors[0])
        switch existingTile?.symbol {
        case .sfSymbol(let name):
            _symbolName = State(initialValue: name)
            _photoFilename = State(initialValue: nil)
            _usesPhoto = State(initialValue: false)
        case .photo(let filename):
            _symbolName = State(initialValue: "star.fill")
            _photoFilename = State(initialValue: filename)
            _usesPhoto = State(initialValue: true)
        case .none:
            _symbolName = State(initialValue: "star.fill")
            _photoFilename = State(initialValue: nil)
            _usesPhoto = State(initialValue: false)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("文字") {
                    TextField("顯示文字", text: $label)
                    TextField("朗讀文字（留空則同顯示文字）", text: $spokenText)
                }

                Section("圖示來源") {
                    Picker("來源", selection: $usesPhoto) {
                        Text("圖示").tag(false)
                        Text("照片").tag(true)
                    }
                    .pickerStyle(.segmented)

                    if usesPhoto {
                        photoSection
                    } else {
                        symbolSection
                    }
                }

                Section("顏色") {
                    colorGrid
                }

                Section {
                    previewTile
                }
            }
            .navigationTitle(existingTile == nil ? "新增圖卡" : "編輯圖卡")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") { save() }
                        .disabled(label.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onChange(of: photoItem) { newItem in
                guard let newItem else { return }
                Task { await loadPhoto(from: newItem) }
            }
        }
    }

    // MARK: - Sections

    private var symbolSection: some View {
        let columns = [GridItem(.adaptive(minimum: 56), spacing: 12)]
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(symbolChoices, id: \.self) { name in
                Image(systemName: name)
                    .font(.title2)
                    .frame(width: 52, height: 52)
                    .background(symbolName == name ? Color(hex: colorHex) : Color(.secondarySystemBackground))
                    .foregroundColor(symbolName == name ? Color(hex: colorHex).readableForeground() : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture { symbolName = name }
            }
        }
        .padding(.vertical, 4)
    }

    private var photoSection: some View {
        VStack(spacing: 12) {
            if let photoFilename, let image = store.loadPhoto(filename: photoFilename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            PhotosPicker(selection: $photoItem, matching: .images) {
                Label(photoFilename == nil ? "從相簿選擇照片" : "更換照片", systemImage: "photo.on.rectangle")
            }
        }
    }

    private var colorGrid: some View {
        let columns = [GridItem(.adaptive(minimum: 44), spacing: 12)]
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(TilePalette.colors, id: \.self) { hex in
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle().stroke(Color.primary, lineWidth: colorHex == hex ? 3 : 0)
                    )
                    .onTapGesture { colorHex = hex }
            }
        }
        .padding(.vertical, 4)
    }

    private var previewTile: some View {
        HStack {
            Spacer()
            TileButtonView(tile: previewModel) {}
                .frame(width: 160)
                .allowsHitTesting(false)
            Spacer()
        }
    }

    private var previewModel: CommunicationTile {
        CommunicationTile(
            label: label.isEmpty ? "預覽" : label,
            spokenText: spokenText,
            symbol: currentSymbol,
            colorHex: colorHex
        )
    }

    private var currentSymbol: SymbolKind {
        if usesPhoto, let photoFilename {
            return .photo(filename: photoFilename)
        }
        return .sfSymbol(symbolName)
    }

    // MARK: - Actions

    private func loadPhoto(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let filename = store.savePhoto(image) else { return }
        await MainActor.run {
            photoFilename = filename
            usesPhoto = true
        }
    }

    private func save() {
        let trimmedSpoken = spokenText.trimmingCharacters(in: .whitespacesAndNewlines)
        let tile = CommunicationTile(
            id: existingTile?.id ?? UUID(),
            label: label.trimmingCharacters(in: .whitespacesAndNewlines),
            spokenText: trimmedSpoken.isEmpty ? nil : trimmedSpoken,
            symbol: currentSymbol,
            colorHex: colorHex
        )
        if existingTile == nil {
            store.addTile(tile, toCategory: categoryID)
        } else {
            store.updateTile(tile, inCategory: categoryID)
        }
        dismiss()
    }
}
