import SwiftUI

struct SpyPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(SpyTheme.darkBackground)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(SpyTheme.primaryGreen)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(SpyTheme.neonGreen, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .spyGlow()
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Primary Button") {}
            .buttonStyle(SpyPrimaryButtonStyle())
        
        Button("Another Button") {}
            .buttonStyle(SpyPrimaryButtonStyle())
    }
    .padding()
    .background(SpyTheme.gradient)
}
