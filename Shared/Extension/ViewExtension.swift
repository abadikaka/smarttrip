//
//  ViewExtension.swift
//  SmartTrip (iOS)
//
//  Created by Michael A.S & Prakosa A.S. on 20/5/2564 BE.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BottomSheet(isPresented: isPresented,
                        height: height,
                        topBarHeight: topBarHeight,
                        topBarCornerRadius: topBarCornerRadius,
                        topBarBackgroundColor: topBarBackgroundColor,
                        contentBackgroundColor: contentBackgroundColor,
                        showTopIndicator: showTopIndicator,
                        content: content)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }

    func shadowBackground(color: Color = .white)  -> some View {
        background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary, lineWidth: 0.2)
        )
    }
}

extension View {
    func borderedView() -> some View {
        font(Font.callout.weight(.semibold))
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 8, style: .continuous
            )
            .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("base"), lineWidth: 1)
        )
        .foregroundColor(Color("base"))
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIDevice {

    enum DeviceType {
        case iphone12ProMax
        case iphone11
        case iphoneX
        case iphone6and7and8
        case iphone7and8Plus
        case iphoneSE
        case iPad
    }

    static func currentType() -> DeviceType {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        }
        let size = UIScreen.main.bounds.height
        if size >= 926 {
            return .iphone12ProMax
        }
        if size >= 896 {
            return .iphone11
        }
        if size >= 812 {
            return .iphoneX
        }
        if size >= 736 {
            return .iphone7and8Plus
        }
        if size >= 667 {
            return .iphone6and7and8
        }
        return .iphoneX
    }

}
