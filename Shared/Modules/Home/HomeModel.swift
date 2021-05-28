//
//  HomeModel.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 16/5/2564 BE.
//

import Foundation

struct EventModel: Identifiable {
    var id: String = UUID().uuidString

    let address: String
    let currency: String
    let closeHour: String
    let openHour: String
    let date: String
    let description: String
    let facilities: [String]
    let gallery: [String]
    let isFavorited: Bool
    let location: Location
    let price: String
    let purchasedTicket: Double
    let rules: [String]
    let totalCapacity: Double
    let title: String
    let type: String
    let picture: String
}
