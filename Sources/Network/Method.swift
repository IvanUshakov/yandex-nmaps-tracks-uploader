//
//  Method.swift
//  
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

extension HTTPClient {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case head = "HEAD"
    }
}
