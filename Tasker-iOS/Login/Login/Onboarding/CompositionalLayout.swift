//
//  CompositionalLayout.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit

enum CompositionalGroupAlignment {
    case vertical
    case horizontal
}

struct CompositionalLayout {
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, spacing: CGFloat) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
    }
    
    static func createGroup(alignment: CompositionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        }
    }
    
    static func createGroup(alignment: CompositionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitem: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: subitem, count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: subitem, count: count)
        }
    }
}
