//
//  AWMozaicLayoutDelegate.swift
//  AWMozaicCollectionViewLayout
//
//  Created by Adam Wienconek on 16/05/20.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

/// The `AWMozaicLayoutDelegate` defines the protocol that let you implement a mozaik layout for `UICollectionView`
public protocol AWMozaicLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
    /// Method should return `AWMozaicLayoutSize` for specific indexPath
    ///
    /// - Parameter collectionView: collection view is using layout
    /// - Parameter layout:         layout itself
    /// - Parameter indexPath:      indexPath of item for the size it asks for
    ///
    /// - Returns: `AWMozaicLayoutSize` struct object describes the size
    func collectionView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, mozaikSizeForItemAt indexPath: IndexPath) -> AWMozaicLayoutSize
    
    /// Method should return `AWMozaicLayoutSectionGeometryInfo` to describe specific section's geometry
    ///
    /// - Parameters:
    ///   - collectionView: collection view is using layout
    ///   - layout:         layout itself
    ///   - section:        section to calculate geometry info for
    ///
    /// - Returns: `AWMozaicLayoutSectionGeometryInfo` struct object describes the section's geometry
    func collectonView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, geometryInfoFor section: Int) -> AWMozaicLayoutSectionGeometryInfo
    
    /// Method should return `AWMozaicLayoutSectionContentMode` to describe specific section's geometry
    ///
    /// - Parameters:
    ///   - collectionView: collection view is using layout
    ///   - layout:         layout itself
    ///   - section:        section to return content mode for
    ///
    /// - Returns: `AWMozaicLayoutSectionContentMode` enum describes the section's content mode and how to position cells
    func collectonView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, contentModeFor section: Int) -> AWMozaicLayoutSectionContentMode
}

public extension AWMozaicLayoutDelegate {
    
    func collectonView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, contentModeFor section: Int) -> AWMozaicLayoutSectionContentMode {
        return AWMozaicLayoutSectionContentMode.fill
    }
}
