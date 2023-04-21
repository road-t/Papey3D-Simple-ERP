//
//  NSColorCodable.swift
//  3D Print Reg
//
//  Created by RT on 11.04.2023.
//

import Cocoa

extension Decodable where Self: NSColor {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let components = try container.decode([CGFloat].self)
        self = Self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

extension Encodable where Self: NSColor {
    public func encode(to encoder: Encoder) throws {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        var container = encoder.singleValueContainer()
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        try container.encode([r,g,b,a])
    }
    
}

extension NSColor: Codable { }
