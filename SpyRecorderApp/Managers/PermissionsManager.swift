import Foundation
import AVFoundation
import UIKit

class PermissionsManager: NSObject, ObservableObject {
    @Published var cameraAuthorized = false
    @Published var microphoneAuthorized = false
    @Published var cameraStatus: AVAuthorizationStatus = .notDetermined
    @Published var microphoneStatus: AVAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        refreshStatuses()
    }
    
    func refreshStatuses() {
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        microphoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        cameraAuthorized = cameraStatus == .authorized
        microphoneAuthorized = microphoneStatus == .authorized
    }
    
    func requestCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            await MainActor.run {
                cameraAuthorized = true
                cameraStatus = .authorized
            }
            return true
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            await MainActor.run {
                cameraAuthorized = granted
                cameraStatus = granted ? .authorized : .denied
            }
            return granted
            
        case .denied, .restricted:
            await MainActor.run {
                cameraAuthorized = false
                cameraStatus = status
            }
            return false
            
        @unknown default:
            await MainActor.run {
                cameraAuthorized = false
                cameraStatus = .denied
            }
            return false
        }
    }
    
    func requestMicrophonePermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            await MainActor.run {
                microphoneAuthorized = true
                microphoneStatus = .authorized
            }
            return true
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .audio)
            await MainActor.run {
                microphoneAuthorized = granted
                microphoneStatus = granted ? .authorized : .denied
            }
            return granted
            
        case .denied, .restricted:
            await MainActor.run {
                microphoneAuthorized = false
                microphoneStatus = status
            }
            return false
            
        @unknown default:
            await MainActor.run {
                microphoneAuthorized = false
                microphoneStatus = .denied
            }
            return false
        }
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func getPermissionStatusText(for type: PermissionType) -> String {
        switch type {
        case .camera:
            switch cameraStatus {
            case .authorized:
                return "Camera access granted"
            case .denied:
                return "Camera access denied. Please enable in Settings."
            case .restricted:
                return "Camera access restricted"
            case .notDetermined:
                return "Camera permission not determined"
            @unknown default:
                return "Camera access unknown"
            }
        case .microphone:
            switch microphoneStatus {
            case .authorized:
                return "Microphone access granted"
            case .denied:
                return "Microphone access denied. Please enable in Settings."
            case .restricted:
                return "Microphone access restricted"
            case .notDetermined:
                return "Microphone permission not determined"
            @unknown default:
                return "Microphone access unknown"
            }
        }
    }
    
    enum PermissionType {
        case camera
        case microphone
    }
}
