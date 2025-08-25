import Foundation
import AVFoundation

class VideoRecorder: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordingDuration: TimeInterval = 0
    
    private var captureSession: AVCaptureSession?
    private var movieOutput: AVCaptureMovieFileOutput?
    private var recordingTimer: Timer?
    weak var storageManager: StorageManager?
    
    override init() {
        super.init()
    }
    
    func startRecording() async -> Bool {
        guard let storageManager = storageManager else { return false }
        
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            print("No video device available")
            return false
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            // Add audio input
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            }
            
            // Add movie output
            let movieOutput = AVCaptureMovieFileOutput()
            if session.canAddOutput(movieOutput) {
                session.addOutput(movieOutput)
                self.movieOutput = movieOutput
            }
            
            self.captureSession = session
            
            // Start session
            session.startRunning()
            
            // Start recording
            let url = storageManager.createRecordingFile(extension: "mov")
            movieOutput.startRecording(to: url, recordingDelegate: self)
            
            await MainActor.run {
                isRecording = true
                recordingDuration = 0
                startTimer()
            }
            
            return true
        } catch {
            print("Error starting video recording: \(error)")
            return false
        }
    }
    
    func stopRecording() {
        movieOutput?.stopRecording()
        captureSession?.stopRunning()
        
        captureSession = nil
        movieOutput = nil
        
        isRecording = false
        recordingDuration = 0
        stopTimer()
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

extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Video recording error: \(error)")
        } else {
            print("Video recording finished successfully")
            // Notify StorageManager to refresh the list
            DispatchQueue.main.async {
                self.storageManager?.refreshRecordings()
            }
        }
    }
}

