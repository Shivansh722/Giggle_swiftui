//
//  color-hex.swift
//  Giggle_swiftui
//
//  Created by user@91 on 31/10/24.
//

import SwiftUI

//making an extension for the struct Color, color define karne ke lie
extension Color {
    
    init(hex: String) {
        //creating a Scanner instance with the hex string as its input(Scanner is a utility in Swift that reads strings)
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0 //variable to convert numberic data of the hex color once it's converted
        
        //scanHexInt64, scans the string and converts it to a 64-bit hex integer storing it in hexNumber
        //'&' reference pass karega hexNumber ko
        scanner.scanHexInt64(&hexNumber)
        
        
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255
        
        //This is extracting the red, green, and blue color components from a hexadecimal color code, then converting them into a format that SwiftUI's Color initializer can use.
        
        self.init(red: r, green: g, blue: b)//this will call self.init with a red, green, blue values to initialise a new Color instance
    }
}
