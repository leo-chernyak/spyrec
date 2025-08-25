import SwiftUI

//struct PrivacyPolicyView: View {
//    @EnvironmentObject private var localization: LocalizationManager
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                SpyTheme.gradient
//                    .ignoresSafeArea()
//                
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        // Header
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Privacy Policy")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(SpyTheme.textPrimary)
//                            
//                            Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
//                                .font(.caption)
//                                .foregroundColor(SpyTheme.textSecondary)
//                        }
//                        
//                        // Content
//                        VStack(alignment: .leading, spacing: 16) {
//                            PolicySection(
//                                title: "Information Collection",
//                                content: "Spy Recorder only records audio and video when you explicitly start recording. We do not collect, store, or transmit any personal information to external servers."
//                            )
//                            
//                            PolicySection(
//                                title: "Local Storage",
//                                content: "All recordings are stored locally on your device. We do not have access to your recordings or any other data on your device."
//                            )
//                            
//                            PolicySection(
//                                title: "Permissions",
//                                content: "The app requests camera and microphone access only for recording purposes. These permissions are clearly indicated by the system and can be revoked at any time in Settings."
//                            )
//                            
//                            PolicySection(
//                                title: "Data Usage",
//                                content: "Recordings are stored in your device's storage and can be exported, shared, or deleted at your discretion. We do not monitor or analyze your recordings."
//                            )
//                            
//                            PolicySection(
//                                title: "Third-Party Services",
//                                content: "This app does not integrate with any third-party services, analytics, or advertising networks."
//                            )
//                            
//                            PolicySection(
//                                title: "Contact",
//                                content: "If you have questions about this privacy policy, please contact us through the app store."
//                            )
//                        }
//                    }
//                    .padding(20)
//                }
//            }
//            .navigationTitle("Privacy Policy")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                    .foregroundColor(SpyTheme.primaryGreen)
//                }
//            }
//        }
//    }
//}
//
//struct PolicySection: View {
//    let title: String
//    let content: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(title)
//                .font(.headline)
//                .fontWeight(.semibold)
//                .foregroundColor(SpyTheme.textPrimary)
//            
//            Text(content)
//                .font(.body)
//                .foregroundColor(SpyTheme.textSecondary)
//                .lineLimit(nil)
//        }
//    }
//}

#Preview {
    PrivacyPolicyView()
        .environmentObject(LocalizationManager())
}
