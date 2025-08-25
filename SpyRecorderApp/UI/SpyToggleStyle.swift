import SwiftUI

struct SpyToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    configuration.isOn.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? SpyTheme.primaryGreen : SpyTheme.textSecondary.opacity(0.3))
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 26, height: 26)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            .offset(x: configuration.isOn ? 10 : -10)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Toggle("Toggle 1", isOn: .constant(true))
            .toggleStyle(SpyToggleStyle())
        
        Toggle("Toggle 2", isOn: .constant(false))
            .toggleStyle(SpyToggleStyle())
    }
    .padding()
    .background(SpyTheme.gradient)
}
