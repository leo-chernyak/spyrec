import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordingDuration: TimeInterval = 0
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingTimer: Timer?
    weak var storageManager: StorageManager?
    
    override init() {
        super.init()
    }
    
    func startRecording() async -> Bool {
        guard let storageManager = storageManager else { return false }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .mixWithOthers])
            try audioSession.setActive(true, options: [])
            
            let url = storageManager.createRecordingFile(extension: "m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            await MainActor.run {
                isRecording = true
                recordingDuration = 0
                startTimer()
            }
            
            return true
        } catch {
            print("Error starting audio recording: \(error)")
            return false
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        isRecording = false
        recordingDuration = 0
        stopTimer()
        
        // Don't deactivate audio session immediately to allow background recording
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("Error deactivating audio session: \(error)")
            }
        }
    }
    
    private func startTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
        }
        
        // Ensure timer continues in background
        RunLoop.current.add(recordingTimer!, forMode: .common)
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Audio recording finished successfully")
            // Notify StorageManager to refresh the list
            DispatchQueue.main.async {
                self.storageManager?.refreshRecordings()
            }
        } else {
            print("Audio recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recording encode error: \(error)")
        }
    }
}

