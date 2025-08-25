import SwiftUI

struct SpyTheme {
    // MARK: - Colors
    static let primaryGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let darkGreen = Color(red: 0.1, green: 0.6, blue: 0.3)
    static let neonGreen = Color(red: 0.0, green: 1.0, blue: 0.5)
    
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.1)
    static let cardBackground = Color(red: 0.1, green: 0.1, blue: 0.15)
    
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.7, green: 0.7, blue: 0.8)
    
    // MARK: - Gradients
    static let gradient = LinearGradient(
        colors: [darkBackground, cardBackground],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let greenGradient = LinearGradient(
        colors: [primaryGreen, neonGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - View Extensions

extension View {
    func spyStyle() -> some View {
        self
            .foregroundColor(SpyTheme.textPrimary)
            .font(.system(size: 16, weight: .medium))
    }
    
    func spyCard() -> some View {
        self
            .background(SpyTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(SpyTheme.primaryGreen.opacity(0.3), lineWidth: 1)
            )
    }
    
    func spyGlow() -> some View {
        self
            .shadow(color: SpyTheme.primaryGreen.opacity(0.5), radius: 10, x: 0, y: 0)
            .shadow(color: SpyTheme.neonGreen.opacity(0.3), radius: 20, x: 0, y: 0)
    }
}

// MARK: - Custom Button Styles

//struct SpyPrimaryButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .font(.system(size: 16, weight: .semibold))
//            .foregroundColor(SpyTheme.darkBackground)
//            .padding(.horizontal, 24)
//            .padding(.vertical, 14)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(SpyTheme.primaryGreen)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(SpyTheme.neonGreen, lineWidth: 1)
//            )
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//            .spyGlow()
//    }
//}
//
//struct SpySecondaryButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .font(.system(size: 16, weight: .semibold))
//            .foregroundColor(SpyTheme.primaryGreen)
//            .padding(.horizontal, 24)
//            .padding(.vertical, 14)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(SpyTheme.cardBackground)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(SpyTheme.primaryGreen, lineWidth: 2)
//            )
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//    }
//}

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
//
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
//
//struct ArticleButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .font(.system(size: 16, weight: .semibold))
//            .foregroundColor(.white)
//            .padding(.horizontal, 20)
//            .padding(.vertical, 12)
//            .background(Color.blue)
//            .cornerRadius(8)
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
//    }
//}
//
//// MARK: - Custom Shapes
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}

#Preview {
    VStack(spacing: 20) {
        Text("Spy Theme Preview")
            .font(.title)
            .foregroundColor(SpyTheme.textPrimary)
        
        Button("Primary Button") {}
            .buttonStyle(SpyPrimaryButtonStyle())
        
        Button("Secondary Button") {}
            .buttonStyle(SpySecondaryButtonStyle())
        
        Toggle("Toggle", isOn: .constant(true))
            .toggleStyle(SpyToggleStyle())
    }
    .padding()
    .background(SpyTheme.gradient)
}

