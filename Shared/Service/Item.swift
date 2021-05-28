//
//  Item.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 22/5/2564 BE.
//

import Foundation

struct Location: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Event: Decodable {
    let id: String
    let currency: String
    let closeHour: Date
    let openHour: Date
    let date: Date
    let description: String
    let facilities: [String]
    let gallery: [String]
    let location: Location
    let picture: String
    let price: Double
    let purchasedTicket: Double
    let rules: [String]
    let title: String
    let totalCapacity: Double
    let type: String
}

struct Purchases: Decodable {
    let date: Date
    let email: String
    let item: String
    let ticketCount: Double
}
