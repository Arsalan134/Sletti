//
//  SearchViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 15.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import CallKit

class SearchViewController: UIViewController {

    
    override func viewDidLoad() {

        let config = CXProviderConfiguration(localizedName: "My App")
        config.iconTemplateImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "sletti-logo"))
        config.ringtoneSound = "ringtone.caf"
        if #available(iOS 11.0, *) {
            config.includesCallsInRecents = false
        } else {
            // Fallback on earlier versions
        };
        config.supportsVideo = false;
        
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
        update.hasVideo = false

    }
    
}

extension SearchViewController: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        print("did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("CXAnswerCallAction")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("CXEndCallAction")
        action.fulfill()
    }
}

//extension SearchViewController: PKPushRegistryDelegate {
//
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
//    }
//
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        let config = CXProviderConfiguration(localizedName: "My App")
//        config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "pizza")!)
//        config.ringtoneSound = "ringtone.caf"
//        config.includesCallsInRecents = false;
//        config.supportsVideo = true;
//        let provider = CXProvider(configuration: config)
//        provider.setDelegate(self, queue: nil)
//        let update = CXCallUpdate()
//        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
//        update.hasVideo = true
//        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
//    }
//}









