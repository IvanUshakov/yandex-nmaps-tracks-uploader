//
//  GPXParserTests.swift
//
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import GPXCore
import XCTest
import CustomDump

class GPXParserTests: XCTestCase {
    func testParseWithoutTracks() throws {
        let text =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Guru Maps/4.9.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gom="https://gurumaps.app/gpx/v2" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd https://gurumaps.app/gpx/v2 https://gurumaps.app/gpx/v2/schema.xsd">
        </gpx>
        """

        let parser = GPXParser(withString: text)!
        let tracks = parser.parse()
        let expected: [Track] = []

        XCTAssertNoDifference(tracks, expected)
    }

    func testParseSingleTrack() throws {
        let text =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Guru Maps/4.9.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gom="https://gurumaps.app/gpx/v2" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd https://gurumaps.app/gpx/v2 https://gurumaps.app/gpx/v2/schema.xsd">
            <trk>
                <name>Track name</name>
            </trk>
        </gpx>
        """

        let parser = GPXParser(withString: text)!
        let tracks = parser.parse()
        let expected: [Track] = [.init(name: "Track name", points: [])]

        XCTAssertNoDifference(tracks, expected)
    }

    func testParseMultiTrack() throws {
        let text =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Guru Maps/4.9.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gom="https://gurumaps.app/gpx/v2" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd https://gurumaps.app/gpx/v2 https://gurumaps.app/gpx/v2/schema.xsd">
            <trk>
                <name>Track name 1</name>
            </trk>
            <trk>
                <name>Track name 2</name>
            </trk>
        </gpx>
        """

        let parser = GPXParser(withString: text)!
        let tracks = parser.parse()
        let expected: [Track] = [
            .init(name: "Track name 1", points: []),
            .init(name: "Track name 2", points: [])
        ]

        XCTAssertNoDifference(tracks, expected)
    }

    func testParseSingleTrackSegment() throws {
        let text =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Guru Maps/4.9.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gom="https://gurumaps.app/gpx/v2" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd https://gurumaps.app/gpx/v2 https://gurumaps.app/gpx/v2/schema.xsd">
            <trk>
                <name>Track name</name>
                <trkseg>
                    <trkpt lat="54.337071" lon="48.445016">
                        <ele>0.0</ele>
                    </trkpt>
                    <trkpt lat="54.296726" lon="48.440210">
                        <ele>0.0</ele>
                    </trkpt>
                </trkseg>
            </trk>
        </gpx>
        """

        let parser = GPXParser(withString: text)!
        let tracks = parser.parse()
        let expected: [Track] = [
            .init(
                name: "Track name",
                points: [
                    .init(latitude: 54.337071, longitude: 48.445016),
                    .init(latitude: 54.296726, longitude: 48.440210)
                ]
            )
        ]

        XCTAssertNoDifference(tracks, expected)
    }

    func testParseMultiTrackSegment() throws {
        let text =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Guru Maps/4.9.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gom="https://gurumaps.app/gpx/v2" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd https://gurumaps.app/gpx/v2 https://gurumaps.app/gpx/v2/schema.xsd">
            <trk>
                <name>Track name</name>
                <trkseg>
                    <trkpt lat="54.337071" lon="48.445016">
                        <ele>0.0</ele>
                    </trkpt>
                    <trkpt lat="54.296726" lon="48.440210">
                        <ele>0.0</ele>
                    </trkpt>
                </trkseg>
                <trkseg>
                    <trkpt lat="54.296726" lon="48.445016">
                        <ele>0.0</ele>
                    </trkpt>
                    <trkpt lat="54.337071" lon="48.440210">
                        <ele>0.0</ele>
                    </trkpt>
                </trkseg>
            </trk>
        </gpx>
        """

        let parser = GPXParser(withString: text)!
        let tracks = parser.parse()
        let expected: [Track] = [
            .init(
                name: "Track name",
                points: [
                    .init(latitude: 54.337071, longitude: 48.445016),
                    .init(latitude: 54.296726, longitude: 48.440210),
                    .init(latitude: 54.296726, longitude: 48.445016),
                    .init(latitude: 54.337071, longitude: 48.440210)
                ]
            )
        ]

        XCTAssertNoDifference(tracks, expected)
    }
}
