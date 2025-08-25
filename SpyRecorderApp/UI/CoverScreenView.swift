import SwiftUI

struct CoverScreenView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var localization: LocalizationManager
    @State private var animateContent = false
    @State private var animateButtons = false
    
    var body: some View {
        ZStack {
            // Background
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        // Magazine Logo
                        HStack {
                            Text("📰")
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("TECH INSIDER")
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                    .foregroundColor(.black)
                                
                                Text("Technology & Innovation")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("2025")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                    
                    // Featured Image
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "cpu.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white)
                                
                                Text("AI Revolution")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        )
                        .padding(.horizontal, 20)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 30)
                    
                    // Article Content
                    VStack(alignment: .leading, spacing: 20) {
                        // Article Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("The Future of Artificial Intelligence: What's Next in 2025?")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                            
                            Text("By Dr. Sarah Chen • Technology Editor")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Article Text
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Artificial Intelligence has evolved dramatically over the past decade, transforming industries and reshaping our daily lives. From autonomous vehicles to advanced language models, the pace of innovation shows no signs of slowing down.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                            
                            Text("In 2025, we're witnessing breakthroughs in quantum computing, edge AI, and sustainable technology. Companies are investing billions in research and development, pushing the boundaries of what's possible.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                            
                            Text("The integration of AI in healthcare, education, and environmental protection is creating new opportunities for solving complex global challenges. As we look ahead, the question isn't whether AI will continue to advance, but how we can harness its potential responsibly.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Buttons
                        HStack(spacing: 16) {
                            Button("Read More") {
                                // Simulate reading more
                            }
                            .buttonStyle(ArticleButtonStyle())
                            
                            Button("Share Article") {
                                // Simulate sharing
                            }
                            .buttonStyle(ArticleButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                        
                        // Go Back Button
                        Button("Go Back") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented = false
                            }
                        }
                        .buttonStyle(SpyPrimaryButtonStyle())
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            animateContent = true
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
            animateButtons = true
        }
    }
}

struct ArticleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    CoverScreenView(isPresented: .constant(true))
        .environmentObject(LocalizationManager())
}

