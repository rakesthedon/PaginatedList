//
//  PaginatedListSectionBuilder.swift
//  PaginatedList
//
//  Created by Yannick Jacques on 2023-05-26.
//

import Foundation

open class PaginatedListSectionBuilder {

    public init() {
    }

    open func buildSections(from items: [any PaginatedListItem]) -> [PaginatedListSection] {
        return [PaginatedListSection(id: "default", title: nil, items: items)]
    }
}
