//
//  FirebaseService.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 22/5/2564 BE.
//

import Foundation
import FirebaseFirestore

struct PurchaseData {
    let date: Date
    let email: String
    let eventId: String
    let ticketCount: Double
}

final class FirebaseService {

    var db: Firestore {
        let firestore = Firestore.firestore()
        return firestore
    }

    func getItems(completion: @escaping (_ items: [Event]) -> Void) {
        let itemsRef = db.collection("items")
        itemsRef.getDocuments { snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var models: [Event] = []
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let closeHour = (data["closeHour"] as! Timestamp).dateValue()
                    let currency = data["currency"] as! String
                    let date = (data["date"] as! Timestamp).dateValue()
                    let description = data["description"] as! String
                    let facilities = data["facilities"] as! [String]
                    let location = data["location"] as! GeoPoint
                    let longitude = location.longitude
                    let latitude = location.latitude
                    let locationModel = Location(latitude: latitude, longitude: longitude)
                    let openHour = (data["openHour"] as! Timestamp).dateValue()
                    let picture = data["picture"] as! String
                    let price = data["price"] as! Double
                    let purchasedTicket = data["purchasedTicket"] as! Double
                    let rules = data["rules"] as! [String]
                    let title = data["title"] as! String
                    let totalCapacity = data["totalCapacity"] as! Double
                    let type = data["type"] as! String
                    let gallery = data["gallery"] as? [String] ?? []
                    let model = Event(id: document.documentID,
                                      currency: currency,
                                      closeHour: closeHour,
                                      openHour: openHour,
                                      date: date,
                                      description: description,
                                      facilities: facilities,
                                      gallery: gallery,
                                      location: locationModel,
                                      picture: picture,
                                      price: price,
                                      purchasedTicket: purchasedTicket,
                                      rules: rules,
                                      title: title,
                                      totalCapacity: totalCapacity,
                                      type: type)
                    models.append(model)
                }
                completion(models)
            }
        }
    }

    func getPurchases(completion: @escaping (_ items: [Purchases]) -> Void) {
        let itemsRef = db.collection("purchases")
        itemsRef.getDocuments { snapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var purchases: [Purchases] = []
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let date = (data["date"] as! Timestamp).dateValue()
                    let email = data["email"] as! String
                    let item = data["item"] as! String
                    let ticketCount = data["ticketCount"] as! Double
                    let purchase = Purchases(date: date, email: email, item: item, ticketCount: ticketCount)
                    purchases.append(purchase)
                }
                completion(purchases)
            }
        }
    }

    func createPurchase(data: PurchaseData, completion: @escaping (Result<Bool, Error>) -> Void) {
        let purchaseData: [String : Any] = [
            "date": Timestamp(date: data.date),
            "email": data.email,
            "item": data.eventId,
            "ticketCount": data.ticketCount
        ]
        db.collection("purchases").addDocument(data: purchaseData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                var allEmails = UserDefaults.standard.stringArray(forKey: "email") ?? [String]()
                if !allEmails.contains(data.email) {
                    allEmails.append(data.email)
                    UserDefaults.standard.setValue(allEmails, forKey: "email")
                }
                completion(.success(true))
            }
        }
    }
}
