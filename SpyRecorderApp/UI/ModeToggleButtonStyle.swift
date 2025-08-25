import SwiftUI

//struct ModeToggleButtonStyle: ButtonStyle {
//    let isSelected: Bool
//    
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .font(.system(size: 14, weight: .semibold))
//            .foregroundColor(isSelected ? SpyTheme.darkBackground : SpyTheme.textSecondary)
//            .padding(.horizontal, 20)
//            .padding(.vertical, 12)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(isSelected ? SpyTheme.primaryGreen : SpyTheme.cardBackground)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(isSelected ? SpyTheme.primaryGreen : SpyTheme.textSecondary.opacity(0.3), lineWidth: 1)
//            )
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//    }
//}

#Preview {
    HStack(spacing: 0) {
        Button("Video") {}
            .buttonStyle(ModeToggleButtonStyle(isSelected: true))
        
        Button("Audio") {}
            .buttonStyle(ModeToggleButtonStyle(isSelected: false))
    }
    .padding()
    .background(SpyTheme.gradient)
}
