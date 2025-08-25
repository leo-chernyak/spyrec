import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var storage: StorageManager
    @EnvironmentObject private var localization: LocalizationManager
    @State private var autoDeleteDays: Double = 7
    @State private var animateSettings = false
    @State private var showPrivacyPolicy = false

    var body: some View {
        ZStack {
            SpyTheme.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerSection
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Language Settings
                        languageSection
                        
                        // Buffer Settings
                        bufferSection
                        
                        // Storage Settings
                        storageSection
                        
                        // About Section
                        aboutSection
                        
                        // Legal Notice
                        legalNoticeSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            autoDeleteDays = Double(storage.autoDeleteDays)
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateSettings = true
            }
        }
        .onChange(of: autoDeleteDays) { _, newValue in
            storage.autoDeleteDays = Int(newValue)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
                .environmentObject(localization)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("settings_title".localized(localization))
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(SpyTheme.primaryGreen)
                .tracking(3)
                .spyGlow()
            
            Text("settings_subtitle".localized(localization))
                .font(.subheadline)
                .foregroundColor(SpyTheme.textSecondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Language Section
    private var languageSection: some View {
        SettingsCard(title: "language_title".localized(localization), icon: "globe") {
            VStack(spacing: 16) {
                ForEach(LocalizationManager.Language.allCases) { language in
                    languageRow(for: language)
                    
                    if language != LocalizationManager.Language.allCases.last {
                        Divider()
                            .background(SpyTheme.textSecondary.opacity(0.3))
                    }
                }
            }
        }
        .opacity(animateSettings ? 1 : 0)
        .offset(y: animateSettings ? 0 : 30)
    }
    
    private func languageRow(for language: LocalizationManager.Language) -> some View {
        HStack {
            Text(language.flag)
                .font(.title2)
            
            Text(language.displayName)
                .foregroundColor(SpyTheme.textPrimary)
            
            Spacer()
            
            if localization.currentLanguage == language {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(SpyTheme.primaryGreen)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                localization.currentLanguage = language
            }
        }
    }
    
    // MARK: - Buffer Section
    private var bufferSection: some View {
        SettingsCard(title: "settings_buffer".localized(localization), icon: "memorychip.fill") {
            VStack(spacing: 16) {
                RecordingBufferControls()
            }
        }
        .opacity(animateSettings ? 1 : 0)
        .offset(y: animateSettings ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateSettings)
    }
    
    // MARK: - Storage Section
    private var storageSection: some View {
        SettingsCard(title: "settings_storage".localized(localization), icon: "externaldrive.fill") {
            VStack(spacing: 16) {
                storageLocationRow
                
                Divider()
                    .background(SpyTheme.textSecondary.opacity(0.3))
                
                autoDeleteSection
            }
        }
        .opacity(animateSettings ? 1 : 0)
        .offset(y: animateSettings ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateSettings)
    }
    
    private var storageLocationRow: some View {
        HStack {
            Text("settings_location".localized(localization))
                .foregroundColor(SpyTheme.textPrimary)
            Spacer()
            Picker("", selection: $storage.storageLocation) {
                ForEach(StorageManager.StorageLocation.allCases) { loc in
                    Text(loc.rawValue.capitalized).tag(loc)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(SpyTheme.primaryGreen)
        }
    }
    
    private var autoDeleteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("settings_auto_delete".localized(localization))
                .foregroundColor(SpyTheme.textPrimary)
            
            HStack {
                Slider(value: $autoDeleteDays, in: 0...30, step: 1)
                    .accentColor(SpyTheme.primaryGreen)
                
                Text("\(Int(autoDeleteDays))д")
                    .font(.caption)
                    .foregroundColor(SpyTheme.textSecondary)
                    .frame(width: 30)
            }
            
            autoDeleteDescription
        }
    }
    
    private var autoDeleteDescription: some View {
        Group {
            if autoDeleteDays == 0 {
                Text("settings_auto_delete_disabled".localized(localization))
            } else {
                Text("settings_auto_delete_days".localizedWithParams(localization, "\(Int(autoDeleteDays))"))
            }
        }
        .font(.caption)
        .foregroundColor(SpyTheme.textSecondary)
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        SettingsCard(title: "settings_about".localized(localization), icon: "info.circle.fill") {
            VStack(spacing: 16) {
                versionRow
                
                Divider()
                    .background(SpyTheme.textSecondary.opacity(0.3))
                
                privacyPolicyButton
                
                Divider()
                    .background(SpyTheme.textSecondary.opacity(0.3))
                
                developerRow
            }
        }
        .opacity(animateSettings ? 1 : 0)
        .offset(y: animateSettings ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateSettings)
    }
    
    private var versionRow: some View {
        HStack {
            Text("settings_version".localized(localization))
                .foregroundColor(SpyTheme.textPrimary)
            Spacer()
            Text("1.0")
                .foregroundColor(SpyTheme.textSecondary)
        }
    }
    
    private var privacyPolicyButton: some View {
        Button("settings_privacy_policy".localized(localization)) {
            showPrivacyPolicy = true
        }
        .foregroundColor(SpyTheme.primaryGreen)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var developerRow: some View {
        HStack {
            Text("settings_developer".localized(localization))
                .foregroundColor(SpyTheme.textPrimary)
            Spacer()
            Text("settings_developer_name".localized(localization))
                .foregroundColor(SpyTheme.textSecondary)
        }
    }
    
    // MARK: - Legal Notice Section
    private var legalNoticeSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(SpyTheme.primaryGreen)
            
            Text("settings_legal_notice".localized(localization))
                .font(.caption)
                .foregroundColor(SpyTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(20)
        .background(SpyTheme.cardBackground.opacity(0.5))
        .cornerRadius(12)
        .opacity(animateSettings ? 1 : 0)
        .offset(y: animateSettings ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateSettings)
    }
}

// MARK: - Settings Card
struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(SpyTheme.primaryGreen)
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(SpyTheme.textPrimary)
                    .tracking(1)
            }
            
            content
        }
        .padding(20)
        .background(SpyTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(SpyTheme.primaryGreen.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localization: LocalizationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                SpyTheme.gradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("privacy_title".localized(localization))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(SpyTheme.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            PolicySection(
                                title: "privacy_data_collection".localized(localization),
                                content: "privacy_data_collection_content".localized(localization)
                            )
                            
                            PolicySection(
                                title: "privacy_usage".localized(localization),
                                content: "privacy_usage_content".localized(localization)
                            )
                            
                            PolicySection(
                                title: "privacy_security".localized(localization),
                                content: "privacy_security_content".localized(localization)
                            )
                            
                            PolicySection(
                                title: "privacy_legality".localized(localization),
                                content: "privacy_legality_content".localized(localization)
                            )
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("privacy_close".localized(localization)) {
                        dismiss()
                    }
                    .foregroundColor(SpyTheme.primaryGreen)
                }
            }
        }
    }
}

// MARK: - Policy Section
struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(SpyTheme.primaryGreen)
            
            Text(content)
                .font(.body)
                .foregroundColor(SpyTheme.textSecondary)
                .lineLimit(nil)
        }
        .padding(16)
        .background(SpyTheme.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(StorageManager())
        .environmentObject(LocalizationManager())
}

