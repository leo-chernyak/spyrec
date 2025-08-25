import Foundation
import SwiftUI

class LocalizationManager: NSObject, ObservableObject {
    enum Language: String, CaseIterable, Identifiable {
        case english = "en"
        case russian = "ru"
        
        var id: String { rawValue }
        
        var flag: String {
            switch self {
            case .english: return "🇺🇸"
            case .russian: return "🇷🇺"
            }
        }
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .russian: return "Русский"
            }
        }
    }
    
    @Published var currentLanguage: Language = .english {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    override init() {
        super.init()
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }
    
    func localizedString(_ key: String) -> String {
        let strings: [Language: [String: String]] = [
            .english: [
                // App
                "app_name": "SPY REC",
                "app_subtitle": "Covert Recording System",
                
                // Tabs
                "tab_record": "Record",
                "tab_export": "Export",
                "tab_settings": "Settings",
                
                // Recording
                "recording_mode": "RECORDING MODE",
                "recording_video": "VIDEO",
                "recording_audio": "AUDIO",
                "recording_ready": "READY FOR MISSION",
                "recording_start": "Start Recording",
                "recording_stop": "Stop Recording",
                "recording_cover_screen": "Cover Screen",
                "recording_save_buffer": "SAVE LAST %@ SECONDS",
                "recording_audio_active": "AUDIO RECORDING",
                "recording_video_active": "VIDEO RECORDING",
                
                // Export
                "export_title": "EXPORT",
                "export_subtitle": "Manage Recordings",
                "export_no_recordings": "No Recordings Found",
                "export_no_recordings_description": "Create your first recording in the Record tab",
                
                // Settings
                "settings_title": "SETTINGS",
                "settings_subtitle": "Configure Your Mission",
                "language_title": "Language",
                "settings_buffer": "Buffer Settings",
                "settings_storage": "Storage Settings",
                "settings_about": "About",
                "settings_location": "Storage Location",
                "settings_auto_delete": "Auto Delete",
                "settings_auto_delete_disabled": "Auto delete disabled",
                "settings_auto_delete_days": "Files will be deleted after %@ days",
                "settings_version": "Version",
                "settings_privacy_policy": "Privacy Policy",
                "settings_developer": "Developer",
                "settings_developer_name": "Spy Rec Team",
                "settings_legal_notice": "Use recordings in compliance with local laws. Obtain consent where required.",
                
                // Buffer Settings
                "settings_active_buffer": "Active Buffer",
                "settings_buffer_description": "Keeps last seconds in memory",
                "settings_buffer_duration": "Buffer Duration",
                
                // Onboarding
                "onboarding_welcome_title": "Welcome, Agent",
                "onboarding_welcome_subtitle": "Your mission: covert recording",
                "onboarding_welcome_description": "Create audio and video recordings with maximum stealth and professional quality.",
                
                "onboarding_instant_title": "Instant Recording",
                "onboarding_instant_subtitle": "One tap - recording started",
                "onboarding_instant_description": "Large record button for quick access. Red dot and timer show activity.",
                
                "onboarding_buffer_title": "Memory Buffer",
                "onboarding_buffer_subtitle": "Save last seconds",
                "onboarding_buffer_description": "Configure buffer to save last 10-120 seconds of audio at any moment.",
                
                "onboarding_cover_screen_title": "Cover Screen",
                "onboarding_cover_screen_subtitle": "Instant disguise",
                "onboarding_cover_screen_description": "During recording, tap 'Cover Screen' to show a fake online magazine. Perfect for situations where you need to hide the app's true purpose.",
                
                "onboarding_widget_title": "Quick Access Widget",
                "onboarding_widget_subtitle": "Always ready",
                "onboarding_widget_description": "Add Spy Recorder widget to your home screen for instant access to recording features. Perfect for quick missions without opening the app.",
                "onboarding_widget_step1": "Long press home screen",
                "onboarding_widget_step2": "Tap + button",
                "onboarding_widget_step3": "Search 'Spy Rec'",
                
                "onboarding_export_title": "Export & Security",
                "onboarding_export_subtitle": "Full data control",
                "onboarding_export_description": "Export recordings, configure auto-delete and choose storage location.",
                
                "onboarding_back": "Back",
                "onboarding_next": "Next",
                "onboarding_start_mission": "Start Mission",
                
                // Permissions
                "permissions_needed": "Permissions Required",
                "permissions_camera_label": "Camera",
                "permissions_microphone_label": "Microphone",
                "permissions_tap_to_settings": "Tap permissions to open Settings",
                "permissions_camera_required": "Camera permission is required for video recording. Please enable it in Settings.",
                "permissions_microphone_required": "Microphone permission is required for recording. Please enable it in Settings.",
                "permissions_open_settings": "Open Settings",
                "permissions_cancel": "Cancel",
                
                // Disclaimer
                "disclaimer_title": "Legal Notice",
                "disclaimer_subtitle": "Important Information",
                "disclaimer_recording_features": "Recording Features",
                "disclaimer_recording_features_content": "This app records audio and video with clear, visible indicators. All recordings are clearly marked and do not attempt to hide system privacy indicators.",
                "disclaimer_legal_compliance": "Legal Compliance",
                "disclaimer_legal_compliance_content": "Use recordings in compliance with local laws and regulations. Obtain proper consent from all parties before recording in situations where it's legally required.",
                "disclaimer_privacy_permissions": "Privacy & Permissions",
                "disclaimer_privacy_permissions_content": "The app requires camera and microphone access. You can manage these permissions in Settings → Privacy & Security → Camera/Microphone.",
                "disclaimer_data_storage": "Data Storage",
                "disclaimer_data_storage_content": "All recordings are stored locally on your device. The app does not upload or share your recordings with any external services.",
                "disclaimer_accept": "I Understand and Accept"
            ],
            .russian: [
                // App
                "app_name": "SPY REC",
                "app_subtitle": "Система скрытой записи",
                
                // Tabs
                "tab_record": "Запись",
                "tab_export": "Экспорт",
                "tab_settings": "Настройки",
                
                // Recording
                "recording_mode": "РЕЖИМ ЗАПИСИ",
                "recording_video": "ВИДЕО",
                "recording_audio": "АУДИО",
                "recording_ready": "ГОТОВ К МИССИИ",
                "recording_start": "Начать запись",
                "recording_stop": "Остановить запись",
                "recording_cover_screen": "Экран-прикрытие",
                "recording_save_buffer": "СОХРАНИТЬ ПОСЛЕДНИЕ %@ СЕКУНД",
                "recording_audio_active": "АУДИО ЗАПИСЬ",
                "recording_video_active": "ВИДЕО ЗАПИСЬ",
                
                // Export
                "export_title": "ЭКСПОРТ",
                "export_subtitle": "Управление записями",
                "export_no_recordings": "Записи не найдены",
                "export_no_recordings_description": "Создайте первую запись в разделе Запись",
                
                // Settings
                "settings_title": "НАСТРОЙКИ",
                "settings_subtitle": "Настройте свою миссию",
                "language_title": "Язык",
                "settings_buffer": "Настройки буфера",
                "settings_storage": "Настройки хранилища",
                "settings_about": "О приложении",
                "settings_location": "Место хранения",
                "settings_auto_delete": "Автоудаление",
                "settings_auto_delete_disabled": "Автоудаление отключено",
                "settings_auto_delete_days": "Файлы будут удалены через %@ дней",
                "settings_version": "Версия",
                "settings_privacy_policy": "Политика конфиденциальности",
                "settings_developer": "Разработчик",
                "settings_developer_name": "Команда Spy Rec",
                "settings_legal_notice": "Используйте записи в соответствии с местными законами. Получите согласие там, где это требуется.",
                
                // Buffer Settings
                "settings_active_buffer": "Активный буфер",
                "settings_buffer_description": "Сохраняет последние секунды в памяти",
                "settings_buffer_duration": "Длительность буфера",
                
                // Onboarding
                "onboarding_welcome_title": "Добро пожаловать, Агент",
                "onboarding_welcome_subtitle": "Ваша миссия: скрытая запись",
                "onboarding_welcome_description": "Создавайте аудио и видео записи с максимальной скрытностью и профессиональным качеством.",
                "onboarding_instant_title": "Мгновенная запись",
                "onboarding_instant_subtitle": "Один тап - запись началась",
                "onboarding_instant_description": "Большая кнопка записи для быстрого доступа. Красная точка и таймер показывают активность.",
                "onboarding_buffer_title": "Буфер памяти",
                "onboarding_buffer_subtitle": "Сохраните последние секунды",
                "onboarding_buffer_description": "Настройте буфер для сохранения последних 10-120 секунд аудио в любой момент.",
                "onboarding_cover_screen_title": "Экран-прикрытие",
                "onboarding_cover_screen_subtitle": "Мгновенная маскировка",
                "onboarding_cover_screen_description": "Во время записи нажмите 'Экран-прикрытие', чтобы показать фальшивый онлайн-журнал. Идеально для ситуаций, когда вам нужно скрыть истинное назначение приложения.",
                
                "onboarding_widget_title": "Быстрый доступ",
                "onboarding_widget_subtitle": "Всегда готов",
                "onboarding_widget_description": "Добавьте виджет Spy Recorder на главный экран для мгновенного доступа к функциям записи. Идеально для быстрых миссий без открытия приложения.",
                "onboarding_widget_step1": "Долгое нажатие на главный экран",
                "onboarding_widget_step2": "Нажмите кнопку +",
                "onboarding_widget_step3": "Найдите 'Spy Rec'",
                
                "onboarding_export_title": "Экспорт и безопасность",
                "onboarding_export_subtitle": "Полный контроль над данными",
                "onboarding_export_description": "Экспортируйте записи, настройте автоудаление и выберите место хранения.",
                "onboarding_back": "Назад",
                "onboarding_next": "Далее",
                "onboarding_start_mission": "Начать миссию",
                
                // Permissions
                "permissions_needed": "Требуются разрешения",
                "permissions_camera_label": "Камера",
                "permissions_microphone_label": "Микрофон",
                "permissions_tap_to_settings": "Нажмите на разрешения, чтобы открыть настройки",
                "permissions_camera_required": "Разрешение на запись видео требуется. Пожалуйста, включите его в настройках.",
                "permissions_microphone_required": "Разрешение на запись требуется. Пожалуйста, включите его в настройках.",
                "permissions_open_settings": "Открыть настройки",
                "permissions_cancel": "Отмена",
                
                // Disclaimer
                "disclaimer_title": "Юридическое уведомление",
                "disclaimer_subtitle": "Важная информация",
                "disclaimer_recording_features": "Функции записи",
                "disclaimer_recording_features_content": "Это приложение записывает аудио и видео с четкими, видимыми индикаторами. Все записи четко отмечены и не пытаются скрывать системные индикаторы конфиденциальности.",
                "disclaimer_legal_compliance": "Юридическое соответствие",
                "disclaimer_legal_compliance_content": "Используйте записи в соответствии с местными законами и правилами. Получите согласие всех сторон перед записью в ситуациях, когда это требуется по закону.",
                "disclaimer_privacy_permissions": "Конфиденциальность и разрешения",
                "disclaimer_privacy_permissions_content": "Приложению требуется доступ к камере и микрофону. Вы можете управлять этими разрешениями в настройках → Конфиденциальность и безопасность → Камера/Микрофон.",
                "disclaimer_data_storage": "Хранение данных",
                "disclaimer_data_storage_content": "Все записи хранятся локально на вашем устройстве. Приложение не загружает и не передает ваши записи ни в какие внешние сервисы.",
                "disclaimer_accept": "Я понимаю и принимаю"
            ]
        ]
        
        return strings[currentLanguage]?[key] ?? key
    }
}

// MARK: - Extensions for easy use

extension LocalizedStringKey {
    func localized(_ manager: LocalizationManager) -> String {
        return manager.localizedString(String(describing: self))
    }
}

extension String {
    func localized(_ manager: LocalizationManager) -> String {
        return manager.localizedString(self)
    }
    
    func localizedWithParams(_ manager: LocalizationManager, _ params: String...) -> String {
        var result = manager.localizedString(self)
        for (index, param) in params.enumerated() {
            result = result.replacingOccurrences(of: "%@", with: param)
        }
        return result
    }
}

