import SwiftUI

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animatePress = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                animatePress = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatePress = false
            }
            action()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(isSelected ? SpyTheme.primaryGreen : SpyTheme.textSecondary)
                    .scaleEffect(animatePress ? 0.9 : 1.0)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? SpyTheme.primaryGreen : SpyTheme.textSecondary)
                    .tracking(0.5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? SpyTheme.primaryGreen.opacity(0.2) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? SpyTheme.primaryGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    HStack {
        TabButton(
            title: "Record",
            icon: "record.circle.fill",
            isSelected: true,
            action: {}
        )
        
        TabButton(
            title: "Export",
            icon: "square.and.arrow.up",
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(SpyTheme.cardBackground)
}
