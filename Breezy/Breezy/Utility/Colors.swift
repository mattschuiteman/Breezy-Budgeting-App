//
//  Sapphire + Emerald.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/11/20.
//

import SwiftUI

extension Color {
    static var emerald:     Color { .rgb(036, 180, 126) }
    static var sapphire:    Color { .rgb(015, 082, 186) }
    static var ruby:        Color { .rgb(224,17,95)     }
    static var mint:      Color { .rgb(170, 240, 209)}
}

extension Color {
    static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> Color {
        func value(_ raw: UInt8) -> Double {
            return Double(raw)/Double(255)
        }
        return Color(
            red: value(red),
            green: value(green),
            blue: value(blue)
        )
    }
}
