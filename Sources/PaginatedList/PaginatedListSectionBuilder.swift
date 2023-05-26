//
//  PaginatedListSectionBuilder.swift
//  PaginatedList
//
//  Created by Yannick Jacques on 2023-05-26.
//

import Foundation

open class PaginatedListSectionBuilder<Item: PaginatedListItem> {

    public init() {
    }

    open func buildSections(from items: [Item]) -> [PaginatedListSection<Item>] {
        return [PaginatedListSection(id: "default", title: nil, items: items)]
    }
}
