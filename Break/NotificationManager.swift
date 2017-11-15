//
//  NotificationManager.swift
//  Break
//
//  Created by Reed Wilson on 11/14/17.
//  Copyright © 2017 Reed Wilson. All rights reserved.
//

import Cocoa

class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    
    var handled: Bool = false
    
    func showNotification() -> Void {
        handled = false
        let notification = NSUserNotification()
        notification.title = "Break Time"
        notification.informativeText = "It's time to take a break!"
        notification.otherButtonTitle = "Skip"
        notification.hasActionButton = true
        notification.actionButtonTitle = "Snooze"
        // Warning: private API
        notification.setValue(true, forKey: "_alwaysShowAlternateActionMenu")
        var actions = [NSUserNotificationAction]()
        actions.append(NSUserNotificationAction(identifier: "minutes1", title: "1 minute"))
        actions.append(NSUserNotificationAction(identifier: "minutes3", title: "3 minutes"))
        actions.append(NSUserNotificationAction(identifier: "minutes5", title: "5 minutes"))
        notification.additionalActions = actions
        notification.soundName = NSUserNotificationDefaultSoundName
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var notificationStillPresent: Bool
            repeat {
                notificationStillPresent = false
                for nox in NSUserNotificationCenter.default.deliveredNotifications {
                    if nox.identifier == notification.identifier {
                        notificationStillPresent = true
                        break
                    }
                }
                
                if notificationStillPresent {
                    let _ = Thread.sleep(forTimeInterval: 0.20)
                }
            } while notificationStillPresent
            
            DispatchQueue.main.async() {
                self.notificationHandlerFor(notification)
            }
        }
    }
    
    func notificationHandlerFor(_ notification: NSUserNotification) {
        if !handled {
            print("resetting!")
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        handled = true
        switch (notification.activationType) {
        case .additionalActionClicked:
            guard let chosen = notification.additionalActivationAction, let id = chosen.identifier else { return }
            print("Action: \(id)")
        case .contentsClicked:
            let delay: TimeInterval = 5
            center.perform(#selector(NSUserNotificationCenter.removeDeliveredNotification(_:)), with: notification, afterDelay: delay)
        default:
            break;
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
