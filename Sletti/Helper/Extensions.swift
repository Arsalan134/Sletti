//
//  Extensions.swift
//  Sletti
//
//  Created by Arsalan Iravani on 15.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import Foundation
import Intents

extension Array {
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows {
        guard let index = try index(where: predicate) else {
            return
        }
        remove(at: index)
    }
}

protocol StartCallConvertible {
    var startCallHandle: String? { get }
    var video: Bool? { get }
}

extension StartCallConvertible {
    
    var video: Bool? {
        return nil
    }
    
}

extension URL: StartCallConvertible {
    
    private struct Constants {
        static let URLScheme = "speakerbox"
    }
    
    var startCallHandle: String? {
        guard scheme == Constants.URLScheme else {
            return nil
        }
        
        return host
    }
    
}


extension NSUserActivity: StartCallConvertible {
    
    var startCallHandle: String? {
        guard
            let interaction = interaction,
            let startCallIntent = interaction.intent as? SupportedStartCallIntent,
            let contact = startCallIntent.contacts?.first
            else {
                return nil
        }
        
        return contact.personHandle?.value
    }
    
    var video: Bool? {
        guard
            let interaction = interaction,
            let startCallIntent = interaction.intent as? SupportedStartCallIntent
            else {
                return nil
        }
        
        return startCallIntent is INStartVideoCallIntent
    }
    
}

protocol SupportedStartCallIntent {
    var contacts: [INPerson]? { get }
}

extension INStartAudioCallIntent: SupportedStartCallIntent {}
extension INStartVideoCallIntent: SupportedStartCallIntent {}


