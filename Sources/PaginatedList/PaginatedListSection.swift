//
//  PaginatedListSection.swift
//  PaginatedList
//
//  Created by Yannick Jacques on 2023-05-26.
//

import Foundation

open class PaginatedListSection<Item: PaginatedListItem>: Identifiable {

    public let id: String
    public let title: String?

    public let items: [Item]

    public init(id: String, title: String?, items: [Item]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

