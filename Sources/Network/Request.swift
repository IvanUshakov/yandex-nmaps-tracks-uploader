//
//  Request.swift
//
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

extension HTTPClient {
    public struct Request {
        public var method: Method
        public var url: String
        public var queryItems: QueryItems
        public var headers: [String: String]
        public var body: Data?
        public var timeout: Int

        public init(
            method: Method = .get,
            url: String,
            queryItems: QueryItems = .init(),
            headers: [String : String] = [:],
            body: Data? = nil,
            timeout: Int = 20
        ) {
            self.method = method
            self.url = url
            self.queryItems = queryItems
            self.headers = headers
            self.body = body
            self.timeout = timeout
        }
    }
}
