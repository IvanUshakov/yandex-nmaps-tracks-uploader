//
//  XMLNodesParser.swift
//
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import Foundation

internal class XMLNodesParser: NSObject {
    private let parser: XMLParser
    private var stack: [XMLNode] = [.init()]

    public init(data: Data) {
        self.parser = .init(data: data)
        super.init()
        parser.delegate = self
    }

    public convenience init?(string: String) {
        guard let data = string.data(using: .utf8) else {
            return nil
        }

        self.init(data: data)
    }

    public func parse() -> XMLNode? {
        parser.parse()
        return stack.first
    }
}

extension XMLNodesParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = XMLNode(tag: elementName, attributes: attributeDict)
        self.stack.append(node)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let last = self.stack.last else {
            return
        }

        self.stack.removeLast()
        self.stack[self.stack.endIndex - 1].children.append(last)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.stack[self.stack.endIndex - 1].content = string
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}
