import SwiftUI

//struct SettingsCard<Content: View>: View {
//    let title: String
//    let icon: String
//    let content: Content
//    
//    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
//        self.title = title
//        self.icon = icon
//        self.content = content()
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Header
//            HStack(spacing: 12) {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(SpyTheme.primaryGreen)
//                    .frame(width: 32, height: 32)
//                
//                Text(title)
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(SpyTheme.textPrimary)
//                
//                Spacer()
//            }
//            
//            // Content
//            content
//        }
//        .padding(20)
//        .background(SpyTheme.cardBackground)
//        .cornerRadius(16)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(SpyTheme.primaryGreen.opacity(0.3), lineWidth: 1)
//        )
//    }
//}
//
//#Preview {
//    SettingsCard(title: "Test Card", icon: "gear") {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Sample content")
//                .foregroundColor(SpyTheme.textPrimary)
//            
//            Text("This is a sample settings card")
//                .foregroundColor(SpyTheme.textSecondary)
//        }
//    }
//    .padding()
//    .background(SpyTheme.gradient)
//}
