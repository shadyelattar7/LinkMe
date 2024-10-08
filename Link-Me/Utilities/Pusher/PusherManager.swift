//
//  PusherManager.swift
//  Link-Me
//
//  Created by Al-attar on 07/12/2023.
//

import Foundation
import PusherSwift

class PusherManager {
    static let shared = PusherManager()
    
    private var pusher: Pusher!

    private init() {
        configurePusher()
    }
    
     func configurePusher() {
        let options = PusherClientOptions(host: .cluster("mt1"))
        pusher = Pusher(key: "59434629f4a4a79f3909", options: options)
        pusher.connection.delegate = self
        pusher.connect()
    }

    func subscribeToChannel(channelName: String, eventName: String, eventCallback: @escaping (PusherEvent) -> Void) {
        let channel = pusher.subscribe(channelName)
        let _ = channel.bind(eventName: eventName, eventCallback: eventCallback)
        
        channel.bind(eventName: "pusher:subscription_error") { event in
              print("Failed to subscribe to channel: \(channelName). Error: \(event.data ?? "No error information available.")")
          }
    }
    
    // Add other functions as needed
    
    func disconnect() {
        pusher.disconnect()
    }
    
    func parseJSON<T: Codable>(jsonString: String?, type: T.Type) -> T? {
        guard let jsonString = jsonString, let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to data.")
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(type, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

extension PusherManager: PusherDelegate {
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        if new == .connected {
            print("Connected to Pusher! 🚀✌🏻")
        } else if new == .disconnected {
            print("Disconnected from Pusher! ❌🙅‍♂️")
        }
    }
}
