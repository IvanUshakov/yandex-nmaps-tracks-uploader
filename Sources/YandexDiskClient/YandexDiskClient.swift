//
//  YandexDiskClient.swift
//
//
//  Created by Ivan Ushakov on 06.01.2024.
//

import Foundation
import Network

public class YandexDiskClient {
    private let key: String
    private let httpClient = HTTPClient()

    public init(key: String) {
        self.key = key
    }

    public func createFolder(path: String) throws {
        let request = HTTPClient.Request(
            method: .put,
            url: "https://cloud-api.yandex.net/v1/disk/resources",
            queryItems: .init {
                $0.add(key: "path", value: path)
            },
            headers: [
                "Accept": "application/json",
                "Authorization": "OAuth \(key)"
            ]
        )

        try httpClient.perform(request: request)
    }

    public func uploadFile(path: String, data: Data) throws {
        let request = HTTPClient.Request(
            method: .get,
            url: "https://cloud-api.yandex.net/v1/disk/resources/upload",
            queryItems: .init {
                $0.add(key: "path", value: path)
            },
            headers: [
                "Accept": "application/json",
                "Authorization": "OAuth \(key)"
            ]
        )

        let response = try httpClient.perform(request: request)
        guard let url = parseHref(response: response) else {
            throw Error.someError
        }

        try uploadFile(url: url, data: data)
    }

    private func parseHref(response: HTTPClient.Response) -> String? {
        let result = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        return result?["href"] as? String
    }

    private func uploadFile(url: String, data: Data) throws {
        let request = HTTPClient.Request(
            method: .put,
            url: url,
            headers: [
                "Accept": "application/json",
                "Authorization": "OAuth \(key)"
            ],
            body: data
        )

        try httpClient.perform(request: request)
    }
}

extension YandexDiskClient {
    enum Error: Swift.Error {
        case someError
    }
}
