import SwiftUI

struct RecordingBufferControls: View {
    @StateObject private var buffer = RollingAudioBuffer()
    @AppStorage("bufferLengthSeconds") private var persistedBufferLength: Int = 30
    @State private var animateToggle = false
    @State private var animateSlider = false
    @State private var sliderValue: Double = 30
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        VStack(spacing: 16) {
            // Toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("settings_active_buffer".localized(localization))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(SpyTheme.textPrimary)
                    
                    Text("settings_buffer_description".localized(localization))
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $buffer.isBuffering)
                    .toggleStyle(SpyToggleStyle())
                    .onChange(of: buffer.isBuffering) { _, newValue in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            animateToggle = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateToggle = false
                        }
                        
                        newValue ? buffer.start() : buffer.stop()
                    }
            
            }
            
            // Buffer Length Slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("settings_buffer_duration".localized(localization))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(SpyTheme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(buffer.bufferLengthSeconds)с")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .scaleEffect(animateSlider ? 1.1 : 1.0)
                }
                
                HStack {
                    Text("10с")
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                    
                    Slider(value: $sliderValue, in: 10...120, step: 5)
                        .accentColor(SpyTheme.primaryGreen)
                        .onChange(of: sliderValue) { _, newValue in
                            buffer.bufferLengthSeconds = Int(newValue)
                            persistedBufferLength = Int(newValue)
                            withAnimation(.spring(response: 0.2)) {
                                animateSlider = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                animateSlider = false
                            }
                        }
                    
                    Text("120с")
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                }
            }
            
            // Quick Save Button
            Button("recording_save_buffer".localizedWithParams(localization, "\(buffer.bufferLengthSeconds)")) {
                Task {
                    _ = await buffer.saveRecent()
                }
            }
            .buttonStyle(SpySecondaryButtonStyle())
            .disabled(!buffer.isBuffering)
            .opacity(buffer.isBuffering ? 1.0 : 0.5)
        }
        .onAppear { 
            buffer.bufferLengthSeconds = persistedBufferLength
            sliderValue = Double(persistedBufferLength)
        }
    }
}

//struct SpyToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            configuration.label
//            Spacer()
//            Button(action: {
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                    configuration.isOn.toggle()
//                }
//            }) {
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(configuration.isOn ? SpyTheme.primaryGreen : SpyTheme.textSecondary.opacity(0.3))
//                    .frame(width: 50, height: 30)
//                    .overlay(
//                        Circle()
//                            .fill(.white)
//                            .frame(width: 26, height: 26)
//                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
//                            .offset(x: configuration.isOn ? 10 : -10)
//                    )
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//    }
//}

#Preview {
    RecordingBufferControls()
        .environmentObject(LocalizationManager())
        .padding()
        .background(SpyTheme.gradient)
}


