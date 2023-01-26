//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public struct Headers {
    private var headers: [Header] = []

    public init() { }

    public init(_ headers: [Header]) {
        self.init()

        headers.forEach { update($0) }
    }

    public init(_ dictionary: [String: String]) {
        self.init()

        dictionary.forEach { update(Header(name: $0.key, value: $0.value)) }
    }

    public mutating func add(name: String, value: String) {
        update(Header(name: name, value: value))
    }

    public mutating func add(_ header: Header) {
        update(header)
    }

    public mutating func update(name: String, value: String) {
        update(Header(name: name, value: value))
    }

    public mutating func update(_ header: Header) {
        guard let index = headers.firstIndex(where: { $0.name.lowercased() == header.name.lowercased()}) else {
            headers.append(header)
            return
        }

        headers[index] = header
    }

    public mutating func remove(name: String) {
        guard let index = headers.firstIndex(where: { $0.name.lowercased() == name.lowercased()}) else { return }

        headers.remove(at: index)
    }

    public mutating func sort() {
        headers.sort { $0.name.lowercased() < $1.name.lowercased() }
    }

    public func sorted() -> Headers {
        var headers = self
        headers.sort()

        return headers
    }

    public func value(for name: String) -> String? {
        guard let index = headers.firstIndex(where: { $0.name.lowercased() == name.lowercased()}) else { return nil }

        return headers[index].value
    }

    public subscript(_ name: String) -> String? {
        get { value(for: name) }
        set {
            if let value = newValue {
                update(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }

    public var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
}

extension Headers: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()

        elements.forEach { update(name: $0.0, value: $0.1) }
    }
}

extension Headers: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Header...) {
        self.init(elements)
    }
}

extension Headers: Sequence {
    public func makeIterator() -> IndexingIterator<[Header]> {
        headers.makeIterator()
    }
}

extension Headers: Collection {
    public var startIndex: Int {
        headers.startIndex
    }

    public var endIndex: Int {
        headers.endIndex
    }

    public subscript(position: Int) -> Header {
        headers[position]
    }

    public func index(after i: Int) -> Int {
        headers.index(after: i)
    }
}

extension Headers: CustomStringConvertible {
    public var description: String {
        headers.map(\.description)
            .joined(separator: "\n")
    }
}
