//
//  GPXTag.swift
//  
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import Foundation

internal enum GPXTag: String, Hashable {
    case gpx
    case track = "trk"
    case name
    case trackSegment = "trkseg"
    case trackPoint = "trkpt"
    case extensions
    case gomTime = "gom:time"
}
