//
//  QRGeneratorView.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 23/5/2564 BE.
//

import Foundation
import SFSymbolsFinder
import SwiftUI
import SwURL

struct QRGeneratorView: View {

    var text: String = "Wenwen OK"

    var body: some View {
        ZStack {
            Color("dark")
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Show Vendor")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white.opacity(0.9))
                    .frame(maxWidth: .infinity)
                Image(uiImage: UIImage(data: getQRCodeDate(text: text)!)!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
    }

    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
}

struct QRGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        QRGeneratorView()
    }
}
