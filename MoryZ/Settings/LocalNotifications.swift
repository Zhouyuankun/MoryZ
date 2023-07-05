//
//  LocalNotifications.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/20.
//

import Foundation
import UserNotifications

class LocalNotifications {
  static var shared = LocalNotifications()

  var lastKnownPermission: UNAuthorizationStatus?
  var userNotificationCenter: UNUserNotificationCenter { UNUserNotificationCenter.current() }

  private init() {
    userNotificationCenter.getNotificationSettings { settings in
      let permission = settings.authorizationStatus
      
      switch permission {
        #if os(iOS)
        case .ephemeral, .provisional: fallthrough
        #endif
          
        case .notDetermined:
          self.requestLocalNotificationPermission(completion: { _ in })
          
        case .authorized, .denied:
          break
          
        @unknown default: break
      }
    }
  }
  
  func createReminder() {
    deleteReminder()
    userNotificationCenter.getNotificationSettings { settings in
      let content = UNMutableNotificationContent()
      content.title = "MoryZ"
      content.subtitle = "Remember to back up"
      
      if settings.soundSetting == .enabled {
        content.sound = UNNotificationSound.default
      }
          
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60 * 60 * 24 * 3), repeats: true)
      
      let reminder = UNNotificationRequest(
        identifier: "MoryZ-reminder",
        content: content,
        trigger: trigger
      )
      
      self.userNotificationCenter.add(reminder)
    }
  }
  
  func deleteReminder() {
    userNotificationCenter.removeAllDeliveredNotifications()
  }
  
  func requestLocalNotificationPermission(completion: @escaping (_ granted: Bool) -> Void) {
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    userNotificationCenter.requestAuthorization(options: options) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(false)
          return
        }
        
        guard granted else {
          completion(false)
          return
        }
        
        completion(true)
      }
    }
  }
}

