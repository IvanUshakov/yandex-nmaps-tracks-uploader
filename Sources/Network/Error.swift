//
//  Error.swift
//  
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

extension HTTPClient {
    public enum Error: Swift.Error {
        case incorrectURL
        case internalError
    }
}
