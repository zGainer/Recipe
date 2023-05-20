//
//  Setting.swift
//  Recipe
//
//  Created by Eugene on 29.04.23.
//

import UIKit

struct Setting {
    
    static let cornerRadius: CGFloat = 5
    
    // Collection Views setting
    static let itemsPerRow: CGFloat = 3
    static let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    static func fetchCollectionLayout() -> UICollectionViewFlowLayout {

        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = sectionInserts
        layout.minimumLineSpacing = sectionInserts.left
        layout.minimumInteritemSpacing = sectionInserts.left

        return layout
    }
    
    static func fetchSizeOfCollectionItem(for collectionWidth: CGFloat) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionWidth - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}
