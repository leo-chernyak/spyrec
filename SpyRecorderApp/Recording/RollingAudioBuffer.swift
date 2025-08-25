import Foundation
import AVFoundation

class RollingAudioBuffer: NSObject, ObservableObject {
    @Published var isBuffering = false
    @Published var bufferLengthSeconds: Int = 30
    
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var buffer: [Float] = []
    private var bufferSize: Int = 0
    private var currentIndex = 0
    
    weak var storageManager: StorageManager?
    
    override init() {
        super.init()
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        guard let inputNode = inputNode else { return }
        
        let format = inputNode.outputFormat(forBus: 0)
        bufferSize = Int(format.sampleRate * Double(bufferLengthSeconds))
        buffer = Array(repeating: 0.0, count: bufferSize)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer)
        }
    }
    
    func start() {
        guard !isBuffering else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioEngine?.prepare()
            try audioEngine?.start()
            
            isBuffering = true
        } catch {
            print("Error starting audio buffer: \(error)")
        }
    }
    
    func stop() {
        guard isBuffering else { return }
        
        audioEngine?.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        
        isBuffering = false
    }
    
    private func processAudioBuffer(_ audioBuffer: AVAudioPCMBuffer) {
        guard let channelData = audioBuffer.floatChannelData?[0] else { return }
        let frameLength = Int(audioBuffer.frameLength)
        
        for i in 0..<frameLength {
            let sample = channelData[i]
            buffer[currentIndex] = sample
            currentIndex = (currentIndex + 1) % bufferSize
        }
    }
    
    func saveRecent() async -> URL? {
        guard let storageManager = storageManager else { return nil }
        
        let url = storageManager.createRecordingFile(extension: "wav")
        
        // Create a simple WAV file from the buffer
        let sampleRate: Double = 44100
        let channels: Int = 1
        let bitsPerSample: Int = 16
        
        let dataSize = bufferSize * channels * bitsPerSample / 8
        let fileSize = 44 + dataSize // WAV header + data
        
        var wavData = Data()
        
        // WAV header
        wavData.append(contentsOf: "RIFF".utf8)
        wavData.append(withUnsafeBytes(of: UInt32(fileSize - 8).littleEndian) { Data($0) })
        wavData.append(contentsOf: "WAVE".utf8)
        
        // fmt chunk
        wavData.append(contentsOf: "fmt ".utf8)
        wavData.append(withUnsafeBytes(of: UInt32(16).littleEndian) { Data($0) }) // fmt chunk size
        wavData.append(withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) }) // audio format (PCM)
        wavData.append(withUnsafeBytes(of: UInt16(channels).littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: UInt32(sampleRate * Double(channels) * Double(bitsPerSample) / 8).littleEndian) { Data($0) }) // byte rate
        wavData.append(withUnsafeBytes(of: UInt16(channels * bitsPerSample / 8).littleEndian) { Data($0) }) // block align
        wavData.append(withUnsafeBytes(of: UInt16(bitsPerSample).littleEndian) { Data($0) })
        
        // data chunk
        wavData.append(contentsOf: "data".utf8)
        wavData.append(withUnsafeBytes(of: UInt32(dataSize).littleEndian) { Data($0) })
        
        // Convert float samples to 16-bit PCM
        for sample in buffer {
            let intSample = Int16(sample * Float(Int16.max))
            wavData.append(withUnsafeBytes(of: intSample.littleEndian) { Data($0) })
        }
        
        do {
            try wavData.write(to: url)
            return url
        } catch {
            print("Error saving audio buffer: \(error)")
            return nil
        }
    }
    
    func updateBufferLength(_ seconds: Int) {
        bufferLengthSeconds = seconds
        bufferSize = Int(44100 * Double(seconds))
        buffer = Array(repeating: 0.0, count: bufferSize)
        currentIndex = 0
    }
}
