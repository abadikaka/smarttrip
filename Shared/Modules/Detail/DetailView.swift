//
//  DetailView.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 19/5/2564 BE.
//

import MapKit
import SFSymbolsFinder
import SwiftUI
import SwURL

struct DetailView: View {

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @Binding var bookingTicketPresented: Bool
    @State var isReadMore: Bool = true

    var item: EventModel?

    enum Constant {
        static let width: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    }

    private var columns: [GridItem] = [
        GridItem(.fixed(Constant.width), alignment: .leading),
        GridItem(.fixed(Constant.width), alignment: .leading),
    ]

    init(bookingTicketPresented: Binding<Bool>, item: EventModel?) {
        UINavigationBar.appearance().barTintColor = UIColor(named: "dark")
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        self._bookingTicketPresented = bookingTicketPresented
        self.item = item
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item?.location.latitude ?? 0, longitude: item?.location.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
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
                        HStack {
                            RemoteImageView(
                                url: URL(string: item!.picture)!,
                                placeholderImage: nil,
                                transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                            ).imageProcessing({ image in
                                return image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 0.6 * geo.size.width, height: 200, alignment: .center)
                                    .cornerRadius(12)
                            })
                            VStack {
                                if item!.gallery.isEmpty {
                                    RemoteImageView(
                                        url: URL(string: item!.picture)!,
                                        placeholderImage: nil,
                                        transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                                    ).imageProcessing({ image in
                                        return image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 0.3 * geo.size.width, alignment: .center)
                                            .frame(maxHeight: 100)
                                            .cornerRadius(12)
                                    })
                                    RemoteImageView(
                                        url: URL(string: item!.picture)!,
                                        placeholderImage: nil,
                                        transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                                    ).imageProcessing({ image in
                                        return image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 0.3 * geo.size.width, alignment: .center)
                                            .frame(maxHeight: 100)
                                            .cornerRadius(12)
                                    })
                                } else {
                                    ForEach(item!.gallery.indices) { index in
                                        RemoteImageView(
                                            url: URL(string: item!.gallery[index])!,
                                            placeholderImage: nil,
                                            transition: .custom(transition: .opacity, animation: .easeOut(duration: 0.5))
                                        ).imageProcessing({ image in
                                            return image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 0.3 * geo.size.width, alignment: .center)
                                                .frame(maxHeight: 100)
                                                .cornerRadius(12)
                                        })
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        .padding(.horizontal, 16)
                        VStack(spacing: 8) {
                            Text(item!.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .frame(width: geo.size.width, alignment: .leading)
                            HStack {
                                All.calendarBadgePlus
                                    .foregroundColor(Color("base"))
                                Text(item!.date)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                                All.clock
                                    .foregroundColor(Color("base"))
                                Text("\(item!.openHour) - \(item!.closeHour)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                                All.person2
                                    .foregroundColor(Color("base"))
                                Text("\(Int(item!.purchasedTicket)) / \(Int(item!.totalCapacity))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                                All.speedometer
                                    .foregroundColor(Color("base"))
                                Text("\(Int(100 - ((item!.purchasedTicket / item!.totalCapacity) * 100).rounded()))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                            }
                            .padding(.horizontal, 16)

                            VStack(alignment: .leading) {
                                Text("Description")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal, 16)
                                    .frame(width: geo.size.width, alignment: .leading)
                                Spacer()
                                if isReadMore {
                                    Text(item!.description)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.9))
                                        .padding(.horizontal, 16)
                                        .frame(width: geo.size.width, alignment: .leading)
                                        .lineLimit(3)
                                } else {
                                    Text(item!.description)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.9))
                                        .padding(.horizontal, 16)
                                        .frame(width: geo.size.width, alignment: .leading)
                                }

                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isReadMore.toggle()
                                    }
                                }, label: {
                                    Text(isReadMore ? "Read more" : "Read less")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("base"))
                                })
                                .padding(.horizontal, 16)
                            }
                            Spacer()
                            Map(coordinateRegion: $region, interactionModes: [.zoom])
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                .frame(width: geo.size.width, height: 150)
                            Spacer()
                            Text("Facilities")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 16)
                                .frame(width: geo.size.width, alignment: .leading)
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16, content: {
                                ForEach (item!.facilities.indices) { index in
                                    HStack {
                                        All.checkmark
                                        Text(item!.facilities[index])
                                            .font(.callout)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            })
                            .padding(.horizontal, 16)
                            .foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                        VStack(spacing: 8) {
                            Text("Rules")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 16)
                                .frame(width: geo.size.width, alignment: .leading)
                            LazyVGrid(columns: columns, alignment: .center, spacing: 16, content: {
                                ForEach (item!.rules.indices) { index in
                                    HStack {
                                        All.checkmarkShield
                                        Text(item!.rules[index])
                                            .font(.callout)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            })
                            .padding(.horizontal, 16)
                            .foregroundColor(.white.opacity(0.9))
                            Spacer()
                                .frame(height: 150)
                        }
                    }
                    Button(action: {
                        bookingTicketPresented.toggle()
                    }, label: {
                        Text("Buy Ticket \(item!.price)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    })
                    .padding()
                    .frame(width: geo.size.width - 32, height: 80)
                    .background(Color("base"))
                    .cornerRadius(35)
                    .offset(y: (geo.size.height / 2) - 80)
                }
            }
            .onAppear {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item?.location.latitude ?? 0, longitude: item?.location.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {

                    }, label: {
                        All.heartFill.image
                    })
                }
            }
        }
    }
}
