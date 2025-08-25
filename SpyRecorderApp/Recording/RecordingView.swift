import SwiftUI

struct RecordingView: View {
    @EnvironmentObject private var permissions: PermissionsManager
    @EnvironmentObject private var audioRecorder: AudioRecorder
    @EnvironmentObject private var videoRecorder: VideoRecorder
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var rollingBuffer = RollingAudioBuffer()
    @AppStorage("bufferLengthSeconds") private var persistedBufferLength: Int = 30
    
    @State private var audioOnly: Bool = false
    @State private var showPermissionAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var animateRecordButton = false
    @State private var animateGlow = false
    @State private var animatePulse = false
    @State private var showStatus = false
    @State private var showCoverScreen = false

    var isRecording: Bool {
        audioRecorder.isRecording || videoRecorder.isRecording
    }
    
    var recordingDuration: TimeInterval {
        audioRecorder.isRecording ? audioRecorder.recordingDuration : videoRecorder.recordingDuration
    }
    
    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("app_name".localized(localization))
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(3)
                        .spyGlow()
                    
                    Text("app_subtitle".localized(localization))
                        .font(.subheadline)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                .padding(.top, 20)
                
                // Mode Toggle
                VStack(spacing: 12) {
                    Text("recording_mode".localized(localization))
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                        .tracking(1)
                    
                    HStack(spacing: 0) {
                        Button("recording_video".localized(localization)) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioOnly = false
                            }
                        }
                        .buttonStyle(ModeToggleButtonStyle(isSelected: !audioOnly))
                        
                        Button("recording_audio".localized(localization)) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioOnly = true
                            }
                        }
                        .buttonStyle(ModeToggleButtonStyle(isSelected: audioOnly))
                    }
                    .spyCard()
                }.padding(.all)
                
                // Recording Status
                VStack(spacing: 16) {
                    if isRecording {
                        VStack(spacing: 12) {
                            // Recording indicator
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 12, height: 12)
                                    .scaleEffect(animatePulse ? 1.2 : 1.0)
                                
                                Text(formatDuration(recordingDuration))
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(SpyTheme.textPrimary)
                            }
                            
                            Text(audioOnly ? "recording_audio_active".localized(localization) : "recording_video_active".localized(localization))
                                .font(.caption)
                                .foregroundColor(SpyTheme.textSecondary)
                                .tracking(1)
                        }
                        .opacity(showStatus ? 1 : 0)
                        .offset(y: showStatus ? 0 : 20)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "eye.slash.fill")
                                .font(.title2)
                                .foregroundColor(SpyTheme.textSecondary)
                            
                            Text("recording_ready".localized(localization))
                                .font(.caption)
                                .foregroundColor(SpyTheme.textSecondary)
                                .tracking(1)
                        }
                        .opacity(showStatus ? 1 : 0)
                        .offset(y: showStatus ? 0 : 20)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isRecording)
                
                // Main Record Button
                Button(action: primaryAction) {
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(SpyTheme.primaryGreen.opacity(0.3))
                            .frame(width: 160, height: 160)
                            .scaleEffect(animateGlow ? 1.2 : 1.0)
                        
                        // Main button
                        Circle()
                            .fill(isRecording ? SpyTheme.cardBackground : SpyTheme.primaryGreen)
                            .frame(width: 140, height: 140)
                            .overlay(
                                Circle()
                                    .stroke(SpyTheme.primaryGreen, lineWidth: 3)
                            )
                        
                        // Icon
                        Image(systemName: isRecording ? "stop.fill" : "record.circle")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(isRecording ? .red : SpyTheme.darkBackground)
                            .scaleEffect(animateRecordButton ? 1.1 : 1.0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(isRecording ? "recording_stop".localized(localization) : "recording_start".localized(localization))
                .spyGlow()
                
                // Cover Screen Button (only when recording)
                if isRecording {
                    Button("recording_cover_screen".localized(localization)) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCoverScreen = true
                        }
                    }
                    .buttonStyle(SpySecondaryButtonStyle())
                    .opacity(showStatus ? 1 : 0)
                    .offset(y: showStatus ? 0 : 20)
                }
                
                // Quick Save Button
                if rollingBuffer.isBuffering {
                    Button("recording_save_buffer".localizedWithParams(localization, "\(rollingBuffer.bufferLengthSeconds)")) {
                        Task { 
                            _ = await rollingBuffer.saveRecent()
                        }
                    }
                    .buttonStyle(SpySecondaryButtonStyle())
                    .opacity(showStatus ? 1 : 0)
                    .offset(y: showStatus ? 0 : 20)
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("settings_legal_notice".localized(localization))
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 20) {
                            Label("permissions_camera_label".localized(localization), systemImage: "camera.fill")
                                .font(.caption)
                                .foregroundColor(permissions.cameraAuthorized ? SpyTheme.primaryGreen : .red)
                            
                            Label("permissions_microphone_label".localized(localization), systemImage: "mic.fill")
                                .font(.caption)
                                .foregroundColor(permissions.microphoneAuthorized ? SpyTheme.primaryGreen : .red)
                        }
                        
                        // Permission status details
                        if !permissions.cameraAuthorized || !permissions.microphoneAuthorized {
                            Text("permissions_tap_to_settings".localized(localization))
                                .font(.caption2)
                                .foregroundColor(SpyTheme.textSecondary)
                                .onTapGesture {
                                    permissions.openSettings()
                                }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            permissions.refreshStatuses()
            rollingBuffer.bufferLengthSeconds = persistedBufferLength
            startAnimations()
            
            // Check permissions and request if needed
            Task {
                if !permissions.cameraAuthorized {
                    _ = await permissions.requestCameraPermission()
                }
                if !permissions.microphoneAuthorized {
                    _ = await permissions.requestMicrophonePermission()
                }
            }
        }
        .alert("permissions_needed".localized(localization), isPresented: $showPermissionAlert) {
            Button("permissions_open_settings".localized(localization)) {
                permissions.openSettings()
            }
            Button("permissions_cancel".localized(localization), role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showCoverScreen) {
            CoverScreenView(isPresented: $showCoverScreen)
                .environmentObject(localization)
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            animateGlow = true
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            animatePulse = true
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
            showStatus = true
        }
    }
    
    private func primaryAction() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        Task {
            // Check and request camera permission if needed for video recording
            if !audioOnly && !permissions.cameraAuthorized {
                let granted = await permissions.requestCameraPermission()
                if !granted {
                    await MainActor.run {
                        alertMessage = "permissions_camera_required".localized(localization)
                        showPermissionAlert = true
                    }
                    return
                }
            }
            
            // Check and request microphone permission if needed
            if !permissions.microphoneAuthorized {
                let granted = await permissions.requestMicrophonePermission()
                if !granted {
                    await MainActor.run {
                        alertMessage = "permissions_microphone_required".localized(localization)
                        showPermissionAlert = true
                    }
                    return
                }
            }
            
            // Now start recording
            if audioOnly {
                let success = await audioRecorder.startRecording()
                if !success {
                    await MainActor.run {
                        alertMessage = "Failed to start audio recording"
                        showPermissionAlert = true
                    }
                }
            } else {
                let success = await videoRecorder.startRecording()
                if !success {
                    await MainActor.run {
                        alertMessage = "Failed to start video recording"
                        showPermissionAlert = true
                    }
                }
            }
        }
    }
    
    private func stopRecording() {
        if audioOnly {
            audioRecorder.stopRecording()
        } else {
            videoRecorder.stopRecording()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ModeToggleButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(isSelected ? SpyTheme.darkBackground : SpyTheme.textSecondary)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? SpyTheme.primaryGreen : Color.clear
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    RecordingView()
        .environmentObject(PermissionsManager())
        .environmentObject(AudioRecorder())
        .environmentObject(VideoRecorder())
        .environmentObject(LocalizationManager())
}

