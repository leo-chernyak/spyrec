import SwiftUI

struct SpySecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(SpyTheme.primaryGreen)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(SpyTheme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(SpyTheme.primaryGreen, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Secondary Button") {}
            .buttonStyle(SpySecondaryButtonStyle())
        
        Button("Another Button") {}
            .buttonStyle(SpySecondaryButtonStyle())
    }
    .padding()
    .background(SpyTheme.gradient)
}
