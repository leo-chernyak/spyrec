import Foundation

class StorageManager: NSObject, ObservableObject {
    enum StorageLocation: String, CaseIterable, Identifiable {
        case temporary = "temporary"
        case documents = "documents"
        
        var id: String { rawValue }
    }
    
    @Published var storageLocation: StorageLocation = .temporary {
        didSet {
            UserDefaults.standard.set(storageLocation.rawValue, forKey: "storageLocation")
        }
    }
    
    @Published var autoDeleteDays: Int = 7 {
        didSet {
            UserDefaults.standard.set(autoDeleteDays, forKey: "autoDeleteDays")
        }
    }
    
    override init() {
        super.init()
        if let savedLocation = UserDefaults.standard.string(forKey: "storageLocation"),
           let location = StorageLocation(rawValue: savedLocation) {
            storageLocation = location
        }
        
        autoDeleteDays = UserDefaults.standard.integer(forKey: "autoDeleteDays")
        if autoDeleteDays == 0 {
            autoDeleteDays = 7
        }
    }
    
    private var storageDirectory: URL {
        switch storageLocation {
        case .temporary:
            return FileManager.default.temporaryDirectory
        case .documents:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
    
    func createRecordingFile(extension: String) -> URL {
        let timestamp = Date().timeIntervalSince1970
        let filename = "recording_\(Int(timestamp)).\(`extension`)"
        let url = storageDirectory.appendingPathComponent(filename)
        print("Created recording file: \(url.lastPathComponent)")
        return url
    }
    
    func listRecordings() -> [URL] {
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: storageDirectory,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            let recordings = files.filter { url in
                let ext = url.pathExtension.lowercased()
                return ext == "mov" || ext == "m4a" || ext == "wav"
            }.filter { url in
                // Only include files that actually exist
                FileManager.default.fileExists(atPath: url.path)
            }.sorted { url1, url2 in
                let date1 = (try? url1.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
                let date2 = (try? url2.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
                return date1 > date2
            }
            
            print("Found \(recordings.count) recordings in \(storageDirectory.path)")
            for recording in recordings {
                print("  - \(recording.lastPathComponent)")
            }
            
            return recordings
        } catch {
            print("Error listing recordings: \(error)")
            return []
        }
    }
    
    func delete(_ url: URL) {
        do {
            // Check if file exists before trying to delete
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
                print("Successfully deleted file: \(url.lastPathComponent)")
                // Trigger UI update
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            } else {
                print("File does not exist: \(url.lastPathComponent)")
            }
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    func pruneIfNeeded(now: Date = Date()) {
        guard autoDeleteDays > 0 else { return }
        let cutoff = now.addingTimeInterval(TimeInterval(-autoDeleteDays * 24 * 60 * 60))
        
        for url in listRecordings() {
            // Double-check file exists before trying to get its modification date
            guard FileManager.default.fileExists(atPath: url.path) else { continue }
            
            let mod = ((try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate) ?? .distantPast
            if mod < cutoff {
                delete(url)
            }
        }
    }
    
    func getStorageInfo() -> (used: Int64, total: Int64) {
        do {
            let values = try storageDirectory.resourceValues(forKeys: [.volumeAvailableCapacityKey, .volumeTotalCapacityKey])
            let available = Int64(values.volumeAvailableCapacity ?? 0)
            let total = Int64(values.volumeTotalCapacity ?? 0)
            let used = total - available
            return (used: used, total: total)
        } catch {
            print("Error getting storage info: \(error)")
            return (used: 0, total: 0)
        }
    }
    
    func refreshRecordings() {
        // Force UI update by triggering objectWillChange
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
