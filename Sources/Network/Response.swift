//
//  Response.swift
//  
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

extension HTTPClient {
    public struct Response {
        public var status: Int
        public var data: Data

        public init(status: Int, data: Data) {
            self.status = status
            self.data = data
        }
    }
}
