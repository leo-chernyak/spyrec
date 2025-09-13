//
//  Spy_RecControl.swift
//  Spy Rec
//
//  Created by Leo Chernyak on 25/08/2025.
//

import WidgetKit
import SwiftUI

struct SimpleProvider: TimelineProvider {
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let recordingStatus: RecordingStatus
    let permissionsGranted: Bool
}

enum RecordingStatus {
    case ready
    case recording
    case noPermissions
}

struct Spy_RecControlEntryView: View {
    var entry: SimpleProvider.Entry

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
                
                // Simple content
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
}

struct Spy_RecControl: Widget {
    let kind: String = "Spy_RecControl"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { entry in
            Spy_RecControlEntryView(entry: entry)
                .containerBackground(LinearGradient(
                    colors: [Color.black, Color(red: 0.1, green: 0.2, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), for: .widget)
        }
        .configurationDisplayName("SAFE REC Simple")
        .description("Simple status widget")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    Spy_RecControl()
} timeline: {
    SimpleEntry(date: Date(), recordingStatus: .ready, permissionsGranted: true)
    SimpleEntry(date: Date(), recordingStatus: .recording, permissionsGranted: true)
    SimpleEntry(date: Date(), recordingStatus: .noPermissions, permissionsGranted: false)
}
