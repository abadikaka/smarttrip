//
//  BookingListView.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 20/5/2564 BE.
//

import SFSymbolsFinder
import SwiftUI
import SwURL

struct BookingListView: View {

    enum DetailType {
        case booking
        case list
    }

    var type: DetailType
    @Binding var bookingTicketPresented: Bool
    @Binding var homeItems: [EventModel]
    @Binding var userItem: [String: String]
    @Binding var userTicket: [String: Double]

    init(bookingTicketPresented: Binding<Bool>, type: DetailType, items: Binding<[EventModel]>, userItem: Binding<[String: String]>, userTicket: Binding<[String: Double]>) {
        self._bookingTicketPresented = bookingTicketPresented
        UINavigationBar.appearance().barTintColor = UIColor(named: "dark")
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        self.type = type
        self._homeItems = items
        self._userItem = userItem
        self._userTicket = userTicket
    }

    func destinationView(_ item: EventModel) -> some View {
        if type == .list {
            return AnyView(DetailView(bookingTicketPresented: $bookingTicketPresented, item: item))
        } else {
            let email = userItem[item.id] ?? ""
            let userTicket = userTicket[item.id] ?? 0
            let text = "Date;\(item.date)-\(item.title)-Email;\(email)-Ticket;\(Int(userTicket.rounded()))"
            return AnyView(QRGeneratorView(text: text))
        }
    }

    var body: some View {
        ZStack {
            Color("dark")
            .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                ZStack {
                    ScrollView(showsIndicators: false) {
                        Spacer()
                            .frame(height: 60)
                        ForEach(homeItems) { item in
                            NavigationLink(destination: destinationView(item)) {
                                LazyVStack {
                                    HStack {
                                        RemoteImageView(
                                            url: URL(string: item.picture)!,
                                            placeholderImage: nil,
                                            transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                                        ).imageProcessing({ image in
                                            return image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(12)
                                        })
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .lineLimit(2)
                                            Spacer()
                                            if type == .booking && (userItem[item.id] != nil) {
                                                Text(userItem[item.id]!)
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                            }
                                            Text(item.date)
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            if type == .booking && (userTicket[item.id] != nil) {
                                                Text("\(Int(userTicket[item.id]!.rounded())) \(All.ticket.image)")
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(type == .list ? "All Event" : "Upcoming Tickets")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
