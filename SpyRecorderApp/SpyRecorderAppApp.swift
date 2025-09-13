//
//  SpyRecorderAppApp.swift
//  SpyRecorderApp
//
//  Created by Leo Chernyak on 24/08/2025.
//

import SwiftUI
import AVFoundation
import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport


/// App entry point for Spy Recorder. Provides a simple Tab UI and injects shared services.
@main
struct SpyRecorderAppApp: App {
    @StateObject private var permissions = PermissionsManager()
    @StateObject private var storage = StorageManager()
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var videoRecorder = VideoRecorder()
    @StateObject private var localization = LocalizationManager()

    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("hasSelectedLanguage") private var hasSelectedLanguage: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = LocalizationManager.Language.english.rawValue
    
    init() {
        // Инициализация SDK
        MobileAds.shared.start(completionHandler: nil)
        
        
        // (Опционально) запрос ATT после первого экрана
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !hasSelectedLanguage {
                    // Language Selection
                    LanguageSelectionView(
                        selectedLanguage: Binding(
                            get: { LocalizationManager.Language(rawValue: selectedLanguage) ?? .english },
                            set: { newValue in
                                selectedLanguage = newValue.rawValue
                                localization.currentLanguage = newValue
                            }
                        ),
                        hasSelectedLanguage: $hasSelectedLanguage
                    )
                    .environmentObject(localization)
                } else if !hasSeenOnboarding {
                    // Onboarding
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                        .environmentObject(localization)
                } else {
                    // Main App
                    RootTabView()
                        .environmentObject(permissions)
                        .environmentObject(storage)
                        .environmentObject(audioRecorder)
                        .environmentObject(videoRecorder)
                        .environmentObject(localization)
                        .onAppear {
                            storage.pruneIfNeeded()
                            audioRecorder.storageManager = storage
                            videoRecorder.storageManager = storage
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            // App is going to background - ensure recording continues
                            if audioRecorder.isRecording || videoRecorder.isRecording {
                                print("App going to background - recording continues")
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                            // App is coming to foreground
                            print("App became active")
                        }
                        .sheet(isPresented: Binding(get: { !hasSeenDisclaimer }, set: { newVal in
                            if newVal == false { hasSeenDisclaimer = true }
                        })) {
                            DisclaimerView(hasSeenDisclaimer: $hasSeenDisclaimer)
                                .environmentObject(localization)
                        }
                }
            }
            .onAppear {
                // Set the selected language
                if let language = LocalizationManager.Language(rawValue: selectedLanguage) {
                    localization.currentLanguage = language
                }
            }
        }
    }
}
