import SwiftUI
import UIKit

/// 負責溝通板資料的載入/儲存與 CRUD，並將照片寫入 Documents。
final class AACStore: ObservableObject {
    @Published var board: AACBoard {
        didSet { save() }
    }

    private let boardFileName = "board.json"
    private let photosDirectoryName = "TilePhotos"

    init() {
        if let loaded = Self.loadFromDisk() {
            board = loaded
        } else {
            board = DefaultData.makeBoard()
            save()
        }
        createPhotosDirectoryIfNeeded()
    }

    // MARK: - 分類 CRUD

    func addCategory(_ category: TileCategory) {
        board.categories.append(category)
    }

    func updateCategory(_ category: TileCategory) {
        guard let index = board.categories.firstIndex(where: { $0.id == category.id }) else { return }
        board.categories[index] = category
    }

    func deleteCategory(id: UUID) {
        board.categories.removeAll { $0.id == id }
    }

    func moveCategories(from source: IndexSet, to destination: Int) {
        board.categories.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - 圖卡 CRUD

    func addTile(_ tile: CommunicationTile, toCategory categoryID: UUID) {
        guard let index = board.categories.firstIndex(where: { $0.id == categoryID }) else { return }
        board.categories[index].tiles.append(tile)
    }

    func updateTile(_ tile: CommunicationTile, inCategory categoryID: UUID) {
        guard let cIndex = board.categories.firstIndex(where: { $0.id == categoryID }),
              let tIndex = board.categories[cIndex].tiles.firstIndex(where: { $0.id == tile.id }) else { return }
        board.categories[cIndex].tiles[tIndex] = tile
    }

    func deleteTile(id: UUID, fromCategory categoryID: UUID) {
        guard let cIndex = board.categories.firstIndex(where: { $0.id == categoryID }) else { return }
        board.categories[cIndex].tiles.removeAll { $0.id == id }
    }

    func moveTiles(from source: IndexSet, to destination: Int, inCategory categoryID: UUID) {
        guard let cIndex = board.categories.firstIndex(where: { $0.id == categoryID }) else { return }
        board.categories[cIndex].tiles.move(fromOffsets: source, toOffset: destination)
    }

    func resetToDefaults() {
        board = DefaultData.makeBoard()
    }

    // MARK: - 照片儲存

    /// 將圖片寫入 Documents/TilePhotos，回傳檔名供 SymbolKind.photo 引用。
    func savePhoto(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = "\(UUID().uuidString).jpg"
        let url = photosDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            print("儲存照片失敗：\(error)")
            return nil
        }
    }

    func loadPhoto(filename: String) -> UIImage? {
        let url = photosDirectory().appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - 持久化

    private func save() {
        do {
            let data = try JSONEncoder().encode(board)
            try data.write(to: Self.boardURL(), options: .atomic)
        } catch {
            print("儲存溝通板失敗：\(error)")
        }
    }

    private static func loadFromDisk() -> AACBoard? {
        guard let data = try? Data(contentsOf: boardURL()) else { return nil }
        return try? JSONDecoder().decode(AACBoard.self, from: data)
    }

    // MARK: - 路徑

    private static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static func boardURL() -> URL {
        documentsDirectory().appendingPathComponent("board.json")
    }

    private func photosDirectory() -> URL {
        Self.documentsDirectory().appendingPathComponent(photosDirectoryName, isDirectory: true)
    }

    private func createPhotosDirectoryIfNeeded() {
        let dir = photosDirectory()
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }
}
