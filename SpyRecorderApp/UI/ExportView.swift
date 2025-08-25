import SwiftUI

struct ExportView: View {
    @EnvironmentObject private var storage: StorageManager
    @EnvironmentObject private var localization: LocalizationManager
    @State private var animateExport = false
    @State private var showShareSheet = false
    @State private var selectedFile: URL?
    
    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("export_title".localized(localization))
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(3)
                        .spyGlow()
                    
                    Text("export_subtitle".localized(localization))
                        .font(.subheadline)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(storage.listRecordings(), id: \.self) { url in
                            FileRowView(
                                url: url,
                                onShare: {
                                    selectedFile = url
                                    showShareSheet = true
                                },
                                onDelete: {
                                    storage.delete(url)
                                    // Force UI update after deletion
                                    DispatchQueue.main.async {
                                        // This will trigger a UI refresh
                                    }
                                }
                            )
                            .opacity(animateExport ? 1 : 0)
                            .offset(y: animateExport ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(Double(storage.listRecordings().firstIndex(of: url) ?? 0) * 0.1), value: animateExport)
                        }
                        
                        if storage.listRecordings().isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 48))
                                    .foregroundColor(SpyTheme.textSecondary)
                                
                                Text("export_no_recordings".localized(localization))
                                    .font(.title3)
                                    .foregroundColor(SpyTheme.textPrimary)
                                
                                Text("export_no_recordings_description".localized(localization))
                                    .font(.body)
                                    .foregroundColor(SpyTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 60)
                            .opacity(animateExport ? 1 : 0)
                            .offset(y: animateExport ? 0 : 30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            // Force refresh of recordings list
            storage.refreshRecordings()
            
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateExport = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // Refresh when app becomes active
            storage.refreshRecordings()
        }
        .sheet(isPresented: $showShareSheet) {
            if let file = selectedFile {
                ShareSheet(activityItems: [file])
            }
        }
    }
}

struct FileRowView: View {
    let url: URL
    let onShare: () -> Void
    let onDelete: () -> Void
    
    @State private var animatePress = false
    
    var body: some View {
        HStack(spacing: 16) {
            // File Icon
            Image(systemName: getFileIcon(for: url))
                .font(.title2)
                .foregroundColor(getFileIconColor(for: url))
                .frame(width: 40, height: 40)
                .background(SpyTheme.cardBackground)
                .cornerRadius(8)
            
            // File Info
            VStack(alignment: .leading, spacing: 4) {
                Text(url.lastPathComponent)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(SpyTheme.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(getFileTypeString(for: url))
                        .font(.caption)
                        .foregroundColor(getFileIconColor(for: url))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(getFileIconColor(for: url).opacity(0.2))
                        .cornerRadius(4)
                    
                    Text(formatFileSize(url: url))
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        animatePress = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animatePress = false
                    }
                    onShare()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .frame(width: 36, height: 36)
                        .background(SpyTheme.cardBackground)
                        .cornerRadius(8)
                        .scaleEffect(animatePress ? 0.95 : 1.0)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        animatePress = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animatePress = false
                    }
                    onDelete()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(width: 36, height: 36)
                        .background(SpyTheme.cardBackground)
                        .cornerRadius(8)
                        .scaleEffect(animatePress ? 0.95 : 1.0)
                }
            }
        }
        .padding(16)
        .background(SpyTheme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(SpyTheme.primaryGreen.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getFileIcon(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        
        switch ext {
        case "mov", "mp4", "avi", "mkv":
            return "video.fill"
        case "m4a", "mp3", "wav", "aac", "flac":
            return "waveform.badge.microphone"
        default:
            return "doc.fill"
        }
    }
    
    private func getFileIconColor(for url: URL) -> Color {
        let ext = url.pathExtension.lowercased()
        
        switch ext {
        case "mov", "mp4", "avi", "mkv":
            return .red // Video files - red
        case "m4a", "mp3", "wav", "aac", "flac":
            return SpyTheme.primaryGreen // Audio files - green
        default:
            return .gray // Other files - gray
        }
    }
    
    private func getFileTypeString(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        
        switch ext {
        case "mov", "mp4", "avi", "mkv":
            return "VIDEO"
        case "m4a", "mp3", "wav", "aac", "flac":
            return "AUDIO"
        default:
            return ext.uppercased()
        }
    }
    
    private func formatFileSize(url: URL) -> String {
        // Check if file exists first
        guard FileManager.default.fileExists(atPath: url.path) else {
            return "File not found"
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[.size] as? Int64 {
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useKB, .useMB, .useGB]
                formatter.countStyle = .file
                return formatter.string(fromByteCount: fileSize)
            }
        } catch {
            print("Error getting file size: \(error)")
        }
        return "Unknown size"
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportView()
        .environmentObject(StorageManager())
        .environmentObject(LocalizationManager())
}

