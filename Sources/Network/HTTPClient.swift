//
//  HTTPClient.swift
//  
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

public class HTTPClient {
    private let session = URLSession.shared

    public init() {}

    @discardableResult
    public func perform(request: Request) throws -> Response {
        let semaphore = DispatchSemaphore(value: 0)

        let request = try buildRequest(request: request)
        var response: Response?
        var responseError: Swift.Error?
        let task = session.dataTask(with: request) { data, urlResponse, error in
            defer {
                semaphore.signal()
            }

            responseError = error
            guard let data, let urlResponse = urlResponse as? HTTPURLResponse else { return } // TODO: set error
            response = .init(status: urlResponse.statusCode, data: data)
        }

        task.resume()
        semaphore.wait()

        if let responseError { throw responseError } // TODO: map errors
        guard let response else { throw Error.internalError }
        return response
    }

    private func buildRequest(request: Request) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: request.url) else { throw Error.incorrectURL }
        urlComponents.percentEncodedQuery = request.queryItems.encoded()
        guard let url = urlComponents.url else { throw Error.incorrectURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = TimeInterval(request.timeout)
        urlRequest.httpBody = request.body
        return urlRequest
    }

}
