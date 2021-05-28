//
//  SearchView.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 18/5/2564 BE.
//

import SFSymbolsFinder
import SwiftUI

struct SearchView: View {

    @Binding var searchTerm: String

    var body: some View {
        HStack {
            Spacer()
            All.magnifyingglass

            TextField("Search", text: self.$searchTerm)
                .foregroundColor(Color.primary)
                .padding(10)

            Spacer()
        }.foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchTerm: .constant(""))
    }
}
