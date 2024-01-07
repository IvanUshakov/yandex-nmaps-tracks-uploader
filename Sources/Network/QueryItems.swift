//
//  QueryItems.swift
//  
//
//  Created by Ivan Ushakov on 07.01.2024.
//

import Foundation

extension HTTPClient {
    public struct QueryItems {
        internal var queryItems: [String: Any] = [:]

        public init() {}

        public init(builder: (inout QueryItems) -> Void) {
            var builderQueryItems = QueryItems()
            builder(&builderQueryItems)
            self.queryItems = builderQueryItems.queryItems
        }

        public mutating func add<T>(key: String, value: T) {
            queryItems[key] = value
        }

        // MARK: - encoding
        public func encoded() -> String {
            queryItems
                .reduce(into: [(key: String, value: String)]()) {
                    $0 += encode(key: $1.key, value: $1.value)
                }
                .map { "\($0)=\($1)" }
                .joined(separator: "&")
        }

        public func encode(key: String, value: Any) -> [(key: String, value: String)] {
            var components: [(key: String, value: String)] = []

            switch value {
            case let dictionary as [String: Any]: encodeDictionary(into: &components, root: key, dictionary: dictionary)
            case let array as [Any]: encodeArray(into: &components, root: key, array: array)
            case let bool as Bool: components.append((key: key, value: bool ? "true" : "false"))
            case let number as any Numeric: components.append((key: key, value: String(describing: number)))
            case let string as any StringProtocol: components.append((key: key, value: escape(string)))
            default: components.append((key: key, value: escape(String(describing: value))))
            }

            return components
        }

        public func encodeDictionary(into components: inout [(key: String, value: String)], root: String, dictionary: [String: Any]) {
            for (nestedKey, value) in dictionary {
                components += encode(key: "\(root)[\(nestedKey)]", value: value)
            }
        }

        public func encodeArray(into components: inout [(key: String, value: String)], root: String, array: [Any]) {
            for value in array {
                components += encode(key: "\(root)[]", value: value)
            }
        }

        public func escape(_ string: any StringProtocol) -> String {
            string.addingPercentEncoding(withAllowedCharacters: Self.urlQueryAllowed) ?? String(string)
        }

        private static let urlQueryAllowed: CharacterSet = {
            let generalDelimitersToEncode = ":#[]@?/"
            let subDelimitersToEncode = "!$&'()*+,;="
            let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
            return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
        }()
    }
}
