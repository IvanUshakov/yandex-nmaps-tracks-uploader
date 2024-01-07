//
//  XMLNode.swift
//  
//
//  Created by Ivan Ushakov on 05.01.2024.
//

import Foundation

internal class XMLNode {
    internal var tag: String
    internal var attributes: [String: String] = [:]
    internal var content: String?
    internal var children: [XMLNode] = []

    init(tag: String = "", attributes: [String: String] = [:], content: String? = nil, children: [XMLNode] = []) {
        self.tag = tag
        self.attributes = attributes
        self.content = content
        self.children = children
    }

    internal func childrenWithTag(tag: GPXTag) -> [XMLNode] {
        children.filter { $0.tag == tag.rawValue }
    }

    internal func firstChildWithTag(tag: GPXTag) -> XMLNode? {
        children.first { $0.tag == tag.rawValue }
    }

    internal func stringAttribute(_ key: GPXAttribute) -> String? {
        attributes[key.rawValue]
    }

    internal func doubleAttribute(_ key: GPXAttribute) -> Double? {
        guard let attribute = stringAttribute(key) else { return nil }
        return Double(attribute)
    }
}
