//
//  PaginatedList.swift
//  PaginatedList
//
//  Created by Yannick Jacques on 2023-05-26.
//

import SwiftUI

public protocol PaginatedListItem: Identifiable {}

public struct PaginatedList<Item: PaginatedListItem, ItemView: View, TitleView: View>: View {

    private let isInitialLoading: Bool
    private let canLoadMore: Bool

    private let sections: [PaginatedListSection<Item>]
    private let onEndListReached: (() -> Void)?
    private let onRefresh: (() -> Void)?

    @ViewBuilder
    private var titleViewBuilder: (_ title: String) -> TitleView

    @ViewBuilder
    private var contentViewBuilder: (_ item: Item) -> ItemView

    public init(isInitialLoading: Bool,
                canLoadMore: Bool,
                sections: [PaginatedListSection<Item>],
                onEndListReached: (() -> Void)? = nil,
                onRefresh: (() -> Void)? = nil,
                @ViewBuilder titleViewBuilder: @escaping (_ title: String) -> TitleView = { _ in EmptyView() },
                @ViewBuilder contentViewBuilder: @escaping (_ item: Item) -> ItemView) {
        self.isInitialLoading = isInitialLoading
        self.canLoadMore = canLoadMore
        self.sections = sections

        self.onEndListReached = onEndListReached
        self.onRefresh = onRefresh

        self.titleViewBuilder = titleViewBuilder
        self.contentViewBuilder = contentViewBuilder
    }


    public var body: some View {
        if isInitialLoading {
            loadingIndicator
        } else {
            if #available(iOS 15, *) {
                list
                    .refreshable {
                        onRefresh?()
                    }
            } else {
                list
            }
        }
    }

    private var list: some View {
        List {
            ForEach(sections) { section in
                ListSection(section: section, titleViewBuilder: titleViewBuilder, contentViewBuilder: contentViewBuilder)
            }

            if canLoadMore {
                loadingIndicator
            }
        }
    }

    @ViewBuilder
    public var loadingIndicator: some View {
        VStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            onEndListReached?()
        }
        .id(UUID())
    }
}

fileprivate struct ListSection<Item: PaginatedListItem, ItemView: View, TitleView: View>: View {

    let section: PaginatedListSection<Item>
    @ViewBuilder var titleViewBuilder: ((_ title: String) -> TitleView)
    @ViewBuilder var contentViewBuilder: (_ item: Item) -> ItemView

    init(section: PaginatedListSection<Item>,
         @ViewBuilder titleViewBuilder: @escaping ((_: String) -> TitleView) = { _ in EmptyView() },
         @ViewBuilder contentViewBuilder: @escaping (_ item: Item) -> ItemView) {
        self.section = section
        self.titleViewBuilder = titleViewBuilder
        self.contentViewBuilder = contentViewBuilder
    }

    @ViewBuilder
    var body: some View {
        if !section.items.isEmpty {
            title
        }

        ForEach(section.items) { item in
            contentViewBuilder(item)
        }
    }

    @ViewBuilder
    var title: some View {
        if let title = section.title {
            titleViewBuilder(title)
        }
    }
}
