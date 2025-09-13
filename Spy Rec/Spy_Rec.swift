//
//  Spy_Rec.swift
//  Spy Rec
//
//  Created by Leo Chernyak on 25/08/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let recordingStatus: RecordingStatus
//    let permissionsGranted: Bool
//}
//
//enum RecordingStatus {
//    case ready
//    case recording
//    case noPermissions
//}

struct Spy_RecEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.black, Color(red: 0.1, green: 0.2, blue: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "eye.slash.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("SAFE REC")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                        .tracking(1)
                    
                    Spacer()
                }
                
                Spacer()
                
                // Main content based on family
                if family == .systemSmall {
                    smallWidgetContent
                } else {
                    mediumWidgetContent
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Text("Tap to open")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(Date().formatted(.dateTime.hour().minute()))
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.gray)
                }
                        }
            .padding(12)
        }
    }
    
    private var smallWidgetContent: some View {
        VStack(spacing: 12) {
            // Status indicator
            ZStack {
                Circle()
                    .fill(entry.recordingStatus == .recording ? .red : .green)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                    )
                
                Image(systemName: entry.recordingStatus == .recording ? "stop.fill" : "record.circle")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(entry.recordingStatus == .recording ? "RECORDING" : "READY")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .tracking(1)
        }
    }
    
    private var mediumWidgetContent: some View {
        HStack(spacing: 16) {
            // Left side - Quick actions
            VStack(spacing: 12) {
                // Audio Recording Button
                Link(destination: URL(string: "spyrecorder://audio")!) {
                    VStack(spacing: 4) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("AUDIO")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.green, lineWidth: 1)
                            )
                    )
                }
                
                // Video Recording Button
                Link(destination: URL(string: "spyrecorder://video")!) {
                    VStack(spacing: 4) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("VIDEO")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.red.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.red, lineWidth: 1)
                            )
                    )
                }
            }
            
            // Right side - Status
            VStack(alignment: .leading, spacing: 8) {
                Text("STATUS")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                    .tracking(1)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(entry.permissionsGranted ? .green : .red)
                            .frame(width: 8, height: 8)
                        
                        Text("Camera")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Circle()
                            .fill(entry.permissionsGranted ? .green : .red)
                            .frame(width: 8, height: 8)
                        
                        Text("Microphone")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Text("Tap buttons to start recording")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct Spy_Rec: Widget {
    let kind: String = "Spy_Rec"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Spy_RecEntryView(entry: entry)
                .containerBackground(LinearGradient(
                    colors: [Color.black, Color(red: 0.1, green: 0.2, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), for: .widget)
                .ignoresSafeArea(.all)
        }
        .configurationDisplayName("SAFE REC")
        .description("Quick access to recording features")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    Spy_Rec()
} timeline: {
    SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
    SimpleEntry(date: Date(), recordingStatus: .recording, permissionsGranted: true)
    SimpleEntry(date: Date(), recordingStatus: .noPermissions, permissionsGranted: false)
}

#Preview(as: .systemMedium) {
    Spy_Rec()
} timeline: {
    SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
}
