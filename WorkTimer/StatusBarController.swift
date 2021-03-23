//
//  StatusBarController.swift
//  WorkTimer
//
//  Created by Michael Kochegarov on 17.03.21.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    
    private var resetButton: NSStatusItem?
    private var button: NSStatusItem?
    private var currentTime: NSStatusItem?
    private var totalTime: NSStatusItem?
    
    var running: Bool = false
    var currentTimeAttributes = [
        NSAttributedString.Key.foregroundColor : NSColor.white,
        NSAttributedString.Key.font: NSFont(name: "Courier New", size: 14)!
    ]
    var totalTimeAttributes = [
        NSAttributedString.Key.foregroundColor : NSColor.white,
        NSAttributedString.Key.font: NSFont(name: "Courier New", size: 14)!
    ]
    
    var startTime: Date = Date()
    var endTime: Date = Date()
    var total: TimeInterval = 0
    
    var timer: Timer?
    
    var playImage = NSImage(named: "play")
    var pauseImage = NSImage(named: "pause")
    var clockImage = NSImage(named: "clock")
        
    init() {
        statusBar = NSStatusBar.init()
        
        resetButton = statusBar.statusItem(withLength: 28)
        if let item = resetButton?.button {
            item.image = clockImage
            item.image?.size = NSSize(width: 18.0, height: 18.0)
            item.image?.isTemplate = true
            item.action = #selector(reset(sender:))
            item.target = self
        }
        
        totalTime = statusBar.statusItem(withLength: 80)
        totalTime?.button?.action = #selector(toggleState(sender:))
        totalTime?.button?.target = self

        currentTime = statusBar.statusItem(withLength: 80)
        currentTime?.button?.action = #selector(toggleState(sender:))
        currentTime?.button?.target = self

        button = statusBar.statusItem(withLength: 28)
        button?.button?.action = #selector(toggleState(sender:))
        button?.button?.target = self

        resetAll()
        update()
    }
    
    @objc
    func reset(sender: AnyObject) {
        if !running && total == 0 {
            return
        }
        
        let alert: NSAlert = NSAlert()
        alert.messageText = "Reset"
        let currentTime = self.currentTime?.button?.title ?? ""
        let totalTime = self.totalTime?.button?.title ?? ""
        let data = String("\nTotal: \(totalTime)\nCurrent: \(currentTime)")
        alert.informativeText = String("Reset current day?\(data)")
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.icon = clockImage
        if alert.runModal() == .alertFirstButtonReturn {
            resetAll()
        }
    }
    
    func resetAll() {
        running = false
        total = 0
        startTime = Date()
        endTime = Date()
        timer?.invalidate()

        update()
    }
    
    @objc
    func toggleState(sender: AnyObject) {
        running = !running
        
        if running {
            startTime = Date()
            endTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                if self.running {
                    self.endTime = Date()
                    self.updateCurrentTime()
                    self.updateTotalTime()
                }
            }
        } else {
            total += endTime.timeIntervalSince(startTime)
            timer?.invalidate()
        }
        update()
    }
    
    func update() {
        if let item = button?.button {
            item.image = running ? pauseImage : playImage
            item.image?.size = NSSize(width: 18.0, height: 18.0)
            item.image?.isTemplate = true
        }

        currentTimeAttributes[NSAttributedString.Key.foregroundColor] = running ? NSColor.green : NSColor.white
        updateCurrentTime()
        updateTotalTime()

    }
    
    func updateCurrentTime() {
        let currentTextValue = stringFromTimeInterval(endTime.timeIntervalSince(startTime))

        currentTime?.button?.attributedTitle =
            NSAttributedString(string: currentTextValue, attributes: currentTimeAttributes)
    }

    func updateTotalTime() {
        var totalTimeValue = total;
        if running {
            totalTimeValue += endTime.timeIntervalSince(startTime);
        }

        let totalTextValue = stringFromTimeInterval(totalTimeValue)
        totalTime?.button?.attributedTitle =
            NSAttributedString(string: totalTextValue, attributes: totalTimeAttributes)
    }

    func stringFromTimeInterval(_ interval: TimeInterval) -> String {
      let ti = NSInteger(interval)
      let seconds = ti % 60
      let minutes = (ti / 60) % 60
      let hours = (ti / 3600)
      return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}
