//
//  HomeView.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 18/5/2564 BE.

import Combine
import Foundation
import SFSymbolsFinder
import SwiftUI
import SwURL

struct HomeView: View {
    private var quantity = ["1", "2", "3", "4", "5"]
    @State private var selectedQuantity = "1"
    @State private var selectedDate = Date()

    @State var searchTerm: String = ""
    @State var height: CGFloat = 0
    @State var selectedEvent: EventType = .tourism
    @State var selectedEventId: String = ""

    private var firebaseService = FirebaseService()

    enum EventType: String, Identifiable, CaseIterable {
        case tourism = "Tourism"
        case event = "Event"
        case museum = "Museum"
        case market = "Market"

        var id: String {
            return rawValue
        }

    }

    @State private var cachedHomeItems: [EventModel] = []
    @State var homeItems: [EventModel] = []
    @State var userItems: [EventModel] = []
    @State var mapUserItem: [String: String] = [:]
    @State var mapUserTicket: [String: Double] = [:]

    @State var bookingTicketPresented: Bool = false
    @State var email: String = ""

    enum Constant {
        static let width: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    }

    private var columns: [GridItem] = [
        GridItem(.fixed(Constant.width), alignment: .center),
        GridItem(.fixed(Constant.width), alignment: .center),
    ]

    private var cancellables = Set<AnyCancellable>()

    private var imageHeight: CGFloat {
        let type = UIDevice.currentType()
        switch type {
        case .iphone6and7and8:
            return 0.45 * UIScreen.main.bounds.height
        case .iphone7and8Plus:
            return 0.45 * UIScreen.main.bounds.height
        case .iphoneSE:
            return 0.45 * UIScreen.main.bounds.height
        case .iphoneX, .iphone11:
            return 0.53 * UIScreen.main.bounds.height
        case .iphone12ProMax, .iPad:
            return 0.53 * UIScreen.main.bounds.height
        }
    }

    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "dark")
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
   }

    var body: some View {
        NavigationView {
            ZStack {
                Color("dark")
                .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    ZStack {
                        ScrollView {
                            VStack {
                                SearchView(searchTerm: $searchTerm)
                                    .padding(4)
                                    .disabled(true)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(EventType.allCases) { type in
                                            VStack {
                                                Text(type.rawValue)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(selectedEvent == type ? .white : Color("base"))
                                            }
                                            .frame(minWidth: 100)
                                            .frame(height: 44)
                                            .background(selectedEvent == type ? Color("base") : .white)
                                            .cornerRadius(22)
                                            .onTapGesture {
                                                withAnimation {
                                                    selectedEvent = type
                                                    homeItems = cachedHomeItems.filter {
                                                        $0.type == selectedEvent.rawValue
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: 44)
                                .padding(.horizontal, 16)
                                HStack {
                                    Text("Nearest Tourism")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    NavigationLink(destination: BookingListView(bookingTicketPresented: $bookingTicketPresented, type: .list, items: $homeItems, userItem: $mapUserItem, userTicket: $mapUserTicket)) {
                                        Text("See All")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color("base"))
                                    }
                                }
                                .frame(height: 36)
                                .padding(.horizontal, 16)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(homeItems) { item in
                                            NavigationLink(
                                                destination:
                                                    DetailView(bookingTicketPresented: $bookingTicketPresented, item: item)
                                                    .onAppear {
                                                        selectedEventId = item.id
                                                    },
                                                label: {
                                                    ZStack {
                                                        RemoteImageView(
                                                            url: URL(string: item.picture)!,
                                                            placeholderImage: nil,
                                                            transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                                                        ).imageProcessing({ image in
                                                            return image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 0.8 * geo.size.width, height: imageHeight)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                                        })
                                                        Rectangle()
                                                        .foregroundColor(.clear)
                                                            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom))
                                                            .clipped()
                                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                                        VStack {
                                                            HStack {
                                                                VStack {
                                                                    Text(item.price)
                                                                        .foregroundColor(.white)
                                                                }
                                                                .padding(6)
                                                                .background(Color.black.opacity(0.5))
                                                                .cornerRadius(4)
                                                                Spacer()
                                                                VStack {
                                                                    All.suitHeartFill
                                                                        .foregroundColor(.white)
                                                                }
                                                                .padding(6)
                                                                .background(Color.black.opacity(0.5))
                                                                .cornerRadius(4)
                                                            }
                                                            .padding()
                                                            Spacer()
                                                            HStack {
                                                                VStack(alignment: .leading) {
                                                                    Text(item.date)
                                                                        .font(.title3)
                                                                        .foregroundColor(.white.opacity(0.8))
                                                                        .fontWeight(.semibold)
                                                                    Text(item.title)
                                                                        .font(.largeTitle)
                                                                        .fontWeight(.semibold)
                                                                        .foregroundColor(.white)
                                                                        .lineLimit(2)
                                                                        .frame(width: 0.6 * geo.size.width, alignment: .leading)
                                                                }
                                                                Spacer()
                                                            }
                                                            .padding()
                                                        }
                                                    }
                                                    .frame(width: 0.8 * geo.size.width, height: imageHeight)
                                            })
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    .padding(.horizontal, 16)
                                }
                                Spacer()
                            }
                        }
                        /*HStack {
                            Spacer()
                                .frame(width: 16)
                            Button(action: {

                            }, label: {
                                All.houseFill
                                    .image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 32)
                                    .foregroundColor(Color.white)
                            })
                            Spacer()
                            Button(action: {

                            }, label: {
                                All.ticket
                                    .image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 32)
                                    .foregroundColor(Color.white.opacity(0.5))
                            })
                            Spacer()
                            Button(action: {

                            }, label: {
                                All.mappinAndEllipse
                                    .image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 32)
                                    .foregroundColor(Color.white.opacity(0.5))
                            })
                            Spacer()
                            Button(action: {

                            }, label: {
                                All.person
                                    .image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 32)
                                    .foregroundColor(Color.white.opacity(0.5))
                            })
                            Spacer()
                                .frame(width: 16)
                        }
                        .padding()
                        .frame(width: geo.size.width - 32, height: 80)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(35)
                        .offset(y: (geo.size.height / 2) - 80)*/
                        NavigationLink(
                            destination: BookingListView(bookingTicketPresented: $bookingTicketPresented, type: .booking, items: $userItems, userItem: $mapUserItem, userTicket: $mapUserTicket),
                            label: {
                                Text("Upcoming Ticket")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                        })
                        .padding()
                        .frame(maxWidth: geo.size.width - 32, maxHeight: 80)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(35)
                        .offset(y: (geo.size.height / 2) - 60)
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading) {
                            Text("Good Morning")
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            Text("Thailand • 5 new events")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .fontWeight(.semibold)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {

                        }, label: {
                            All.qrcodeViewfinder.image
                        })
                    }
                }
            }
        }
        .bottomSheet(isPresented: $bookingTicketPresented, height: (0.44 * UIScreen.main.bounds.height) + (height > 0 ? height + 170 : height)) {
            ScrollView() {
                VStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Email")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            All.mail.image
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Color("base")
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("base"), lineWidth: 2)
                                )
                                .onTapGesture {

                                }
                            TextField("Put Your Email", text: $email)
                                .borderedView()
                                .foregroundColor(Color("base"))
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                        }
                    }
                    .padding(.horizontal, 16)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Choose Day")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            All.calendar.image
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Color("base")
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("base"), lineWidth: 2)
                                )
                                .onTapGesture {

                                }
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .frame(maxWidth: 120)
                                .accentColor(Color("base"))
                        }
                    }
                    .padding(.horizontal, 16)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Choose Quantity")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack {
                            All.ticket.image
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Color("base")
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("base"), lineWidth: 2)
                                )
                                .onTapGesture {

                                }
                            Picker(selection: $selectedQuantity, label: Text("\(selectedQuantity) Ticket")
                                    .frame(maxWidth: .infinity)) {
                                ForEach(quantity, id: \.self, content: { quantity in
                                    Text(quantity)
                                })
                            }
                            .frame(maxWidth: .infinity)
                            .borderedView()
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(Color("base"))
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                    Button(action: {
                        let purchaseData = PurchaseData(date: selectedDate, email: email, eventId: selectedEventId, ticketCount: Double(selectedQuantity) ?? 1)
                        firebaseService.createPurchase(data: purchaseData) { result in
                            switch result {
                            case .success:
                                bookingTicketPresented.toggle()
                            case .failure:
                                break
                            }
                            firebaseService.getPurchases { purchases in
                                let userItem = purchases.map { $0.item }
                                let mapItem = purchases.reduce(into: [String: String]()) {
                                    $0[$1.item] = $1.email
                                }
                                let mapUserTicket = purchases.reduce(into: [String: Double]()) {
                                    $0[$1.item] = $1.ticketCount
                                }

                                userItems = cachedHomeItems.filter {
                                    userItem.contains($0.id)
                                }

                                mapUserItem = mapItem
                                self.mapUserTicket = mapUserTicket
                            }
                        }
                    }, label: {
                        Text("Buy Ticket")
                            .frame(maxWidth: .infinity)
                    })
                    .padding()
                    .background(
                        RoundedRectangle(
                            cornerRadius: 8, style: .continuous
                        )
                        .fill(Color("base"))
                    )
                    .padding(.horizontal, 16)
                }
                .animation(.spring())
            }
            .onAppear {
                firebaseService.getItems { events in
                    if cachedHomeItems.isEmpty {
                        cachedHomeItems = events.map {
                            return EventModel(id: $0.id, address: "", currency: $0.currency, closeHour: hourFormatter.string(from: $0.closeHour), openHour: hourFormatter.string(from: $0.openHour), date: formatter.string(from: $0.date), description: $0.description, facilities: $0.facilities, gallery: $0.gallery, isFavorited: false, location: $0.location, price: "\($0.price) \($0.currency)", purchasedTicket: $0.purchasedTicket, rules: $0.rules, totalCapacity: $0.totalCapacity, title: $0.title, type: $0.type, picture: $0.picture)
                        }
                    }

                    homeItems = cachedHomeItems.filter {
                        $0.type == selectedEvent.rawValue
                    }

                    firebaseService.getPurchases { purchases in
                        let userItem = purchases.map { $0.item }
                        let mapItem = purchases.reduce(into: [String: String]()) {
                            $0[$1.item] = $1.email
                        }
                        let mapUserTicket = purchases.reduce(into: [String: Double]()) {
                            $0[$1.item] = $1.ticketCount
                        }

                        userItems = cachedHomeItems.filter {
                            userItem.contains($0.id)
                        }

                        mapUserItem = mapItem
                        self.mapUserTicket = mapUserTicket
                    }
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.height = height
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                   self.height = 0
                }
            }
        }
        .accentColor(.white)
    }

    var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMMM dd, yyyy"
        return df
    }

    var hourFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        return formatter
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
