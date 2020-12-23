//
//  AWMozaicLayoutCache.swift
//  AWMozaicCollectionViewLayout
//
//  Created by Adam Wienconek on 29/05/20.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

/// The `AWMozaicLayoutCache` defines the class with the purpose to reuse information from collection view and layout delegate
class AWMozaicLayoutCache {
    
    /// Stores number of sections in collection view
    fileprivate var cachedNumberOfSections: Int?
    
    /// Stores number of items in specific section
    fileprivate var cachedNumberOfItemsInSectionDictionary: [Int: Int]
    
    /// Stores number size of item at specific indexPath
    fileprivate var cachedSizeOfItemAtIndexPathDictionary: [IndexPath: AWMozaicLayoutSize]
    
    /// Reference to collectionView
    fileprivate let collectionView: UICollectionView
    
    /// Reference to mozaik layout delegate
    fileprivate weak var mozaikLayoutDelegate: AWMozaicLayoutDelegate?
    
    ///
    /// Designated initializer for the `AWMozaicLayoutCache`
    ///
    /// - Parameter collectionView:       attached to layout collection view
    /// - Parameter mozaikLayoutDelegate: layout delegate
    ///
    /// - Returns: newly created class `AWMozaicLayoutCache`
    init(collectionView: UICollectionView, mozaikLayoutDelegate: AWMozaicLayoutDelegate) {
        self.collectionView = collectionView
        self.mozaikLayoutDelegate = mozaikLayoutDelegate
        self.cachedNumberOfItemsInSectionDictionary = [:]
        self.cachedSizeOfItemAtIndexPathDictionary = [:]
    }
    
    //MARK: - Interface
    
    ///
    /// Returns number of items in the given section
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - Parameter section: section number to get number of items in
    ///
    /// - Returns: number of items in the given section
    func numberOfItemsInSection(_ section: Int) -> Int {
        if self.cachedNumberOfItemsInSectionDictionary[section] == nil {
            self.cachedNumberOfItemsInSectionDictionary[section] = self.collectionView.numberOfItems(inSection: section)
        }
        return self.cachedNumberOfItemsInSectionDictionary[section]!
    }
    
    ///
    /// Returns number of sections in attached collectionView
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - Returns: number of sections in attached collectionView
    func numberOfSections() -> Int {
        if self.cachedNumberOfSections == nil {
            self.cachedNumberOfSections = self.collectionView.numberOfSections
        }
        return self.cachedNumberOfSections!
    }
    
    ///
    /// Returns size for an item at the given indexPath
    /// It either uses the cached value or the value from collectionView and caches it
    ///
    /// - Parameter indexPath: index path to get the size of an item at
    ///
    /// - Returns: size for an item at the given indexPath
    func mozaikSizeForItem(atIndexPath indexPath: IndexPath) -> AWMozaicLayoutSize {
        guard let delegate = self.mozaikLayoutDelegate else {
            fatalError("AWMozaicLayoutCache must have delegate")
        }
        guard let layout = self.collectionView.collectionViewLayout as? AWMozaicLayout else {
            fatalError("collectionView must have AWMozaicLayout")
        }
        if let size = self.cachedSizeOfItemAtIndexPathDictionary[indexPath] {
            return size
        }
        return delegate.collectionView(self.collectionView, mozaik: layout, mozaikSizeForItemAt: indexPath)
    }
}
