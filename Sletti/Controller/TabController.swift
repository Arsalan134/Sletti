//
//  TabController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 04.03.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase
import CallKit
import PushKit

class TabController: UITabBarController {
    
    var provider: CXProvider?
    var update: CXCallUpdate = CXCallUpdate()
    var config: CXProviderConfiguration = CXProviderConfiguration(localizedName: "Sletti")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red:0.9882, green:0.1451, blue:0.8314, alpha:1.0000)
        self.tabBar.unselectedItemTintColor = UIColor(red:0.5333, green:0.5333, blue:0.5333, alpha:1.0000)
        
        if let items = self.tabBar.items {
            for item in items {
                item.image = item.image?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedCall(notification:)), name: NSNotification.Name("recievedCall"), object: nil)
        
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]
        
        config.iconTemplateImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "sletti-logo"))
        config.ringtoneSound = "ringtone.caf"
        if #available(iOS 11.0, *) {
            config.includesCallsInRecents = false
        } else {
            // Fallback on earlier versions
        }
        config.supportsVideo = false
        
        provider = CXProvider(configuration: config)
        guard provider != nil else {return}
        provider?.setDelegate(self, queue: nil)
        
        update.remoteHandle = CXHandle(type: .generic, value: Auth.auth().currentUser?.displayName ?? "")
        update.hasVideo = false
    }
    
    @objc func recievedCall(notification: Notification) {
        var userID = "Anonymous"
        
        if let userID2 = notification.userInfo?["remoteUserID"] as? String {
          userID = userID2
        }
        
        print("Call from", userID)
        
        update.localizedCallerName = userID
        provider?.reportNewIncomingCall(with: UUID(), update: update) { (error) in }
    }
}

extension TabController: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        print("did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("CXAnswerCallAction")
        action.fulfill()
        NotificationCenter.default.post(name: NSNotification.Name("answer"), object: nil)
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("CXEndCallAction")
        NotificationCenter.default.post(name: NSNotification.Name("stopTalking"), object: nil)
        action.fulfill()
    }
}

extension TabController: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        let config = CXProviderConfiguration(localizedName: "My App")
        config.iconTemplateImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "user"))
        config.ringtoneSound = "ringtone.caf"
        if #available(iOS 11.0, *) {
            config.includesCallsInRecents = false
        } else {
            // Fallback on earlier versions
        }
        config.supportsVideo = false
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: Auth.auth().currentUser?.displayName ?? "Anonymous")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }
}


