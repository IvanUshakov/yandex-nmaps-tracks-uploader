//
//  GPX.swift
//
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import Foundation

public struct Track: Hashable {
    public var name: String?
    public var date: Date?
    public var points: [Point]

    public init(name: String?, points: [Point], date: Date? = nil) {
        self.name = name
        self.points = points
        self.date = date
    }
}

extension Track {
    public struct Point: Hashable {
        public let latitude: Double
        public let longitude: Double

        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
