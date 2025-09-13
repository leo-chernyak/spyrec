import SwiftUI

struct LaunchScreenView: View {
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var animateGlow = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [SpyTheme.darkBackground, SpyTheme.cardBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Logo
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(SpyTheme.primaryGreen.opacity(0.3))
                        .frame(width: 160, height: 160)
                        .scaleEffect(animateGlow ? 1.2 : 1.0)
                    
                    // Main logo circle
                    Circle()
                        .fill(SpyTheme.greenGradient)
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(SpyTheme.neonGreen, lineWidth: 3)
                        )
                    
                    // Icon
                    Image(systemName: "eye.slash.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(SpyTheme.darkBackground)
                        .scaleEffect(animateLogo ? 1.1 : 1.0)
                }
                .spyGlow()
                
                // App Name
                VStack(spacing: 8) {
                    Text("SAFE REC")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(4)
                        .spyGlow()
                    
                    Text("Covert Recording System")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(SpyTheme.textSecondary)
                        .tracking(1)
                }
                .opacity(animateText ? 1 : 0)
                .offset(y: animateText ? 0 : 30)
                
                Spacer()
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(SpyTheme.primaryGreen)
                            .frame(width: 8, height: 8)
                            .scaleEffect(animateLogo ? 1.2 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: animateLogo
                            )
                    }
                }
                .opacity(animateText ? 1 : 0)
                .offset(y: animateText ? 0 : 20)
                
                // Version
                Text("v1.0")
                    .font(.caption)
                    .foregroundColor(SpyTheme.textSecondary)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
            animateLogo = true
        }
        
        withAnimation(.easeOut(duration: 1.0).delay(0.6)) {
            animateText = true
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            animateGlow = true
        }
    }
}

#Preview {
    LaunchScreenView()
}
