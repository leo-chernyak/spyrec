import SwiftUI

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: LocalizationManager.Language
    @Binding var hasSelectedLanguage: Bool
    @State private var animateSelection = false
    @State private var animateButtons = false
    
    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Text("SPY REC")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(3)
                        .spyGlow()
                    
                    Text("Choose Your Language")
                        .font(.title2)
                        .foregroundColor(SpyTheme.textPrimary)
                        .opacity(animateSelection ? 1 : 0)
                        .offset(y: animateSelection ? 0 : 20)
                    
                    Text("Выберите язык")
                        .font(.title3)
                        .foregroundColor(SpyTheme.textSecondary)
                        .opacity(animateSelection ? 1 : 0)
                        .offset(y: animateSelection ? 0 : 20)
                }
                
                // Language Options
                VStack(spacing: 20) {
                    ForEach(LocalizationManager.Language.allCases) { language in
                        LanguageOptionButton(
                            language: language,
                            isSelected: selectedLanguage == language,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedLanguage = language
                                }
                            }
                        )
                        .opacity(animateSelection ? 1 : 0)
                        .offset(x: animateSelection ? 0 : -50)
                        .animation(.easeOut(duration: 0.6).delay(Double(LocalizationManager.Language.allCases.firstIndex(of: language) ?? 0) * 0.1), value: animateSelection)
                    }
                }
                
                Spacer()
                
                // Continue Button
                Button("Continue / Продолжить") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasSelectedLanguage = true
                    }
                }
                .buttonStyle(SpyPrimaryButtonStyle())
                .padding(.horizontal, 40)
                .opacity(animateButtons ? 1 : 0)
                .offset(y: animateButtons ? 0 : 30)
                
                Spacer()
            }
            .padding(.vertical, 40)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            animateSelection = true
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            animateButtons = true
        }
    }
}

struct LanguageOptionButton: View {
    let language: LocalizationManager.Language
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
            HStack(spacing: 20) {
                Text(language.flag)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(SpyTheme.textPrimary)
                    
                    Text(language == .english ? "Default language" : "Язык по умолчанию")
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(SpyTheme.primaryGreen)
                        .scaleEffect(animatePress ? 1.2 : 1.0)
                }
            }
            .padding(20)
            .background(SpyTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? SpyTheme.primaryGreen : SpyTheme.textSecondary.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(animatePress ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LanguageSelectionView(
        selectedLanguage: .constant(.english),
        hasSelectedLanguage: .constant(false)
    )
}
