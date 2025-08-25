import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    @State private var animateTabs = false
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Tab Content
                TabView(selection: $selectedTab) {
                    RecordingView()
                        .tag(0)
                    
                    ExportView()
                        .tag(1)
                    
                    SettingsView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                // Custom Tab Bar
                HStack(spacing: 0) {
                    TabButton(
                        title: "tab_record".localized(localization),
                        icon: "record.circle.fill",
                        isSelected: selectedTab == 0,
                        action: { withAnimation { selectedTab = 0 } }
                    )
                    
                    TabButton(
                        title: "tab_export".localized(localization),
                        icon: "square.and.arrow.up",
                        isSelected: selectedTab == 1,
                        action: { withAnimation { selectedTab = 1 } }
                    )
                    
                    TabButton(
                        title: "tab_settings".localized(localization),
                        icon: "gear",
                        isSelected: selectedTab == 2,
                        action: { withAnimation { selectedTab = 2 } }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(SpyTheme.cardBackground)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .overlay(
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                        .stroke(SpyTheme.primaryGreen.opacity(0.3), lineWidth: 1)
                )
                .opacity(animateTabs ? 1 : 0)
                .offset(y: animateTabs ? 0 : 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animateTabs = true
            }
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RootTabView()
        .environmentObject(LocalizationManager())
}
