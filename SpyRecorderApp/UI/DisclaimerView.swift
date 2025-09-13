import SwiftUI

struct DisclaimerView: View {
    @Binding var hasSeenDisclaimer: Bool
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("disclaimer_title".localized(localization))
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(SpyTheme.primaryGreen)
                        .tracking(2)
                        .spyGlow()
                        .padding()
                    
                    Text("disclaimer_subtitle".localized(localization))
                        .font(.subheadline)
                        .foregroundColor(SpyTheme.textSecondary)
                }
                .padding(.top, 40)
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    disclaimerSection(
                        title: "disclaimer_recording_features".localized(localization),
                        content: "disclaimer_recording_features_content".localized(localization)
                    )
                    
                    disclaimerSection(
                        title: "disclaimer_legal_compliance".localized(localization),
                        content: "disclaimer_legal_compliance_content".localized(localization)
                    )
                    
                    disclaimerSection(
                        title: "disclaimer_privacy_permissions".localized(localization),
                        content: "disclaimer_privacy_permissions_content".localized(localization)
                    )
                    
                    disclaimerSection(
                        title: "disclaimer_data_storage".localized(localization),
                        content: "disclaimer_data_storage_content".localized(localization)
                    )
                }
                .padding(.horizontal, 20)
                
                AdBannerView(adUnitID: "ca-app-pub-2785489394463863/1247654289")
                                .frame(width: 320, height: 50)
                                .padding()
                
                Spacer()
                
                // Button
                Button("disclaimer_accept".localized(localization)) {
                    hasSeenDisclaimer = true
                }
                .buttonStyle(SpyPrimaryButtonStyle())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    
    private func disclaimerSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(SpyTheme.primaryGreen)
                .tracking(1)
            
            Text(content)
                .font(.body)
                .foregroundColor(SpyTheme.textSecondary)
                .lineLimit(nil)
        }
    }
}

#Preview {
    DisclaimerView(hasSeenDisclaimer: .constant(false))
        .environmentObject(LocalizationManager())
}
