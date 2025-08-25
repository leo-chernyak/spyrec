import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject private var localization: LocalizationManager
    @State private var currentPage = 0
    @State private var animateGlow = false
    @State private var animatePulse = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "onboarding_welcome_title",
            subtitle: "onboarding_welcome_subtitle",
            description: "onboarding_welcome_description",
            icon: "eye.slash.fill",
            color: SpyTheme.primaryGreen
        ),
        OnboardingPage(
            title: "onboarding_instant_title",
            subtitle: "onboarding_instant_subtitle",
            description: "onboarding_instant_description",
            icon: "record.circle.fill",
            color: SpyTheme.neonGreen
        ),
        OnboardingPage(
            title: "onboarding_buffer_title",
            subtitle: "onboarding_buffer_subtitle",
            description: "onboarding_buffer_description",
            icon: "memorychip.fill",
            color: SpyTheme.darkGreen
        ),
        OnboardingPage(
            title: "onboarding_cover_screen_title",
            subtitle: "onboarding_cover_screen_subtitle",
            description: "onboarding_cover_screen_description",
            icon: "newspaper.fill",
            color: SpyTheme.neonGreen
        ),
        OnboardingPage(
            title: "onboarding_widget_title",
            subtitle: "onboarding_widget_subtitle",
            description: "onboarding_widget_description",
            icon: "rectangle.stack.fill",
            color: SpyTheme.darkGreen
        ),
        OnboardingPage(
            title: "onboarding_export_title",
            subtitle: "onboarding_export_subtitle",
            description: "onboarding_export_description",
            icon: "lock.shield.fill",
            color: SpyTheme.primaryGreen
        )
    ]
    
    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("app_name".localized(localization))
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(2)
                    
                    Spacer()
                    
                    Text("v1.0")
                        .font(.caption)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                .padding()
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? SpyTheme.primaryGreen : SpyTheme.textSecondary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Action Buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button("onboarding_back".localized(localization)) {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .buttonStyle(SpySecondaryButtonStyle())
                    }
                    
                    Button(currentPage == pages.count - 1 ? "onboarding_start_mission".localized(localization) : "onboarding_next".localized(localization)) {
                        if currentPage == pages.count - 1 {
                            hasSeenOnboarding = true
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
                    .buttonStyle(SpyPrimaryButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            animateGlow = true
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            animatePulse = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @EnvironmentObject private var localization: LocalizationManager
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.2 : 1.0)
            }
            .spyGlow()
            
            // Text Content
            VStack(spacing: 16) {
                Text(page.title.localized(localization))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(SpyTheme.textPrimary) // White text
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.subtitle.localized(localization))
                    .font(.title3)
                    .foregroundColor(page.color) // Green subtitle
                    .fontWeight(.semibold)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description.localized(localization))
                    .font(.body)
                    .foregroundColor(SpyTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                // Widget installation instructions (only for widget page)
                if page.title == "onboarding_widget_title" {
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(SpyTheme.primaryGreen)
                            Text("onboarding_widget_step1".localized(localization))
                                .font(.caption)
                                .foregroundColor(SpyTheme.textSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(SpyTheme.primaryGreen)
                            Text("onboarding_widget_step2".localized(localization))
                                .font(.caption)
                                .foregroundColor(SpyTheme.textSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "3.circle.fill")
                                .foregroundColor(SpyTheme.primaryGreen)
                            Text("onboarding_widget_step3".localized(localization))
                                .font(.caption)
                                .foregroundColor(SpyTheme.textSecondary)
                        }
                    }
                    .padding(.top, 16)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateIcon = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                animateText = true
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
        .environmentObject(LocalizationManager())
}
