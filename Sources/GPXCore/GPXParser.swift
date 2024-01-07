//
//  GPXParser.swift
//
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import Foundation

public class GPXParser {
    private var parser: XMLNodesParser
    private var dateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()

    public init(withData data: Data) {
        self.parser = .init(data: data)
    }

    public convenience init?(withString string: String) {
        guard let data = string.data(using: .utf8) else {
            return nil
        }

        self.init(withData: data)
    }

    public func parse() -> [Track] {
        let nodes = parser.parse()
        let gpx = nodes?.firstChildWithTag(tag: .gpx)
        let tracks = gpx?.childrenWithTag(tag: .track) ?? []

        return tracks.compactMap { node -> Track? in
            let name = parseTrackName(node: node)
            let date = parseTrackDate(node: node)
            let points = parseTrackPoints(node: node)
            return Track(name: name, points: points, date: date)
        }
    }

    private func parseTrackName(node: XMLNode) -> String? {
        node.firstChildWithTag(tag: .name)?.content
    }

    private func parseTrackDate(node: XMLNode) -> Date? {
        node
            .firstChildWithTag(tag: .extensions)?
            .firstChildWithTag(tag: .gomTime)?
            .content
            .flatMap { self.dateFormatter.date(from: $0) }
    }

    private func parseTrackPoints(node: XMLNode) -> [Track.Point] {
        node
            .childrenWithTag(tag: .trackSegment)
            .reduce(into: []) {
                $0.append(contentsOf: $1.childrenWithTag(tag: .trackPoint))
            }
            .compactMap { node in
                guard let lat = node.doubleAttribute(.lat) else { return nil }
                guard let lon = node.doubleAttribute(.lon) else { return nil }
                return Track.Point(latitude: lat, longitude: lon)
            }
    }
}
