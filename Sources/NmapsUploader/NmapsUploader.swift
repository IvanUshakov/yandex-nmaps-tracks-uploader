import Foundation
import ArgumentParser
import YandexDiskClient
import GPXCore

@main
struct NmapsUploader: ParsableCommand {
    @Option(name: .shortAndLong, help: "")
    var key: String

    @Argument(help: "", completion: .file())
    var inputFile: String

    mutating func run() throws {
        let path = resolveFilePath(file: inputFile)
        guard let gpxString = try? String(contentsOfFile: path) else {
            fatalError("Can't load gpx data from \(path)")
        }

        guard let parser = GPXParser(withString: gpxString) else {
            return
        }

        let yandexDiskClient = YandexDiskClient(key: key)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let tracks = parser.parse()
        print("Loaded \(tracks.count) tracks from \(path)")
        for track in tracks {
            try? uploadTarck(track: track, dateFormatter: dateFormatter, yandexDiskClient: yandexDiskClient)
        }
    }

    func resolveFilePath(file: String) -> String {
        if file == "~" {
            return FileManager.default.homeDirectoryForCurrentUser.path
        }

        if file.hasPrefix("~/") {
            var components = file.split(separator: "/").map(String.init)
            components.removeFirst()
            components.insert(FileManager.default.homeDirectoryForCurrentUser.path, at: 0)
            return components.joined(separator: "/")
        }

        return file
    }

    func uploadTarck(track: Track, dateFormatter: DateFormatter, yandexDiskClient: YandexDiskClient) throws {
        let data = try trackToNMaps(track: track)
        let folderName = folderName(track: track, dateFormatter: dateFormatter)
        let folderPath = "Приложения/Блокнот картографа Народной карты/_" + folderName
        let filePath = folderPath + "/" + "index.json"

        print("Start uploading \(folderName)")
        try yandexDiskClient.createFolder(path: folderPath)
        print("Created \(folderPath)")
        try yandexDiskClient.uploadFile(path: filePath, data: data)
        print("Did upload \(folderName)")
    }

    func folderName(track: Track, dateFormatter: DateFormatter) -> String {
        let date = track.date.flatMap { dateFormatter.string(from: $0) }
        guard let date else { return track.name ?? "unkonown" }
        return date + " " + (track.name ?? "unkonown")
    }

    func trackToNMaps(track: Track) throws -> Data {
        let key = UUID().uuidString
        let points = track.points
            .map { [$0.longitude, $0.latitude] }

        let data = [
            "paths": [key: points],
            "points": [:]
        ]

        return try JSONSerialization.data(withJSONObject: data)
    }
}
