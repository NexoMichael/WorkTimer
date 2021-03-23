//
//  WorkTimerApp.swift
//  WorkTimer
//
//  Created by Michael Kochegarov on 17.03.21.
//

import SwiftUI
import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController.init()
    }
}

@main
struct WorkTimerApp : App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Welcome to Work Timer!").frame(width: 300, height: 100, alignment: .center)
    }
}
