//
//  AWMozaicLayoutAttributes.swift
//  AWMozaicCollectionViewLayout
//
//  Created by Adam Wienconek on 14/06/20.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

/// Enum with the all possible errors generated by `AWMozaicLayoutAttributes`
///
/// - notAllSectionsPrepared: missing information for collectionView section
enum AWMozaicLayoutAttributesError: Error {
    case notAllSectionsPrepared
}

class AWMozaicLayoutAttributes {
    
    /// Array of `UICollectionViewLayoutAttributes`
    fileprivate(set) var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
    
    /// Array of unified rects of each 20 layout attributes
    fileprivate(set) var unionRectsArray: [CGRect] = []
    
    /// Default number of attributes in one union
    fileprivate let AWMozaicLayoutUnionSize: Int = 20
    
    /// AWMozaicLayout cache reference
    fileprivate let layoutCache: AWMozaicLayoutCache
    
    init(layoutCache: AWMozaicLayoutCache, layoutMatrixes: [AWMozaicLayoutSectionMatrix], layoutGeometries: [AWMozaicLayoutSectionGeometry]) throws {
        self.layoutCache = layoutCache
        self.layoutAttributesArray = try self.buildLayoutAttributesForLayoutGeometries(layoutGeometries, withLayoutMatrixes: layoutMatrixes)
        self.unionRectsArray = self.buildUnionRectsFromLayoutAttributes(self.layoutAttributesArray)
    }
    
    //MARK: - Interface
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesArray[indexPath.item]
    }
    
    func layoutAttributesForElementsInRect(_ rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let resultAttributes: [UICollectionViewLayoutAttributes] = layoutAttributesArray.compactMap { attributes in
            guard rect.intersects(attributes.frame) else {
                return nil
            }
            return attributes
        }

        return resultAttributes
    }
    
    //MARK: - Helper
    
    fileprivate func buildLayoutAttributesForLayoutGeometries(_ layoutGeometries: [AWMozaicLayoutSectionGeometry], withLayoutMatrixes layoutMatrixes: [AWMozaicLayoutSectionMatrix]) throws -> [UICollectionViewLayoutAttributes] {
        let numberOfSections = layoutCache.numberOfSections()
        guard layoutGeometries.count == numberOfSections && layoutMatrixes.count == numberOfSections else {
            throw AWMozaicLayoutAttributesError.notAllSectionsPrepared
        }
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        var layoutSectionGeometryOffsetY: CGFloat = 0
        for section in 0..<numberOfSections {
            let itemsCount = layoutCache.numberOfItemsInSection(section)
            let layoutGeometry = layoutGeometries[section]
            let layoutMatrix = layoutMatrixes[section]
            
            if let attributes = buildLayoutAttributesForSupplementaryView(of: UICollectionView.elementKindSectionHeader, in: section, geometry: layoutGeometry, additionalOffsetY: layoutSectionGeometryOffsetY) {
                allAttributes.append(attributes)
            }
            
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                do {
                    let attributes = try buildLayoutAttributesForItem(at: indexPath, geometry: layoutGeometry, matrix: layoutMatrix, additionalOffsetY: layoutSectionGeometryOffsetY)
                    allAttributes.append(attributes)
                }
                catch let error as CustomStringConvertible {
                    fatalError(error.description)
                }
            }
            
            if let attributes = buildLayoutAttributesForSupplementaryView(of: UICollectionView.elementKindSectionFooter, in: section, geometry: layoutGeometry, additionalOffsetY: layoutSectionGeometryOffsetY) {
                allAttributes.append(attributes)
            }
            
            layoutSectionGeometryOffsetY += layoutGeometry.contentHeight
        }
        return allAttributes
    }
    
    fileprivate func buildLayoutAttributesForSupplementaryView(of kind: String, in section: Int, geometry: AWMozaicLayoutSectionGeometry, additionalOffsetY: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let frame = geometry.frameForSupplementaryView(of: kind) else {
            return nil
        }
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        attributes.frame = CGRect(x: frame.origin.x, y: frame.origin.y + additionalOffsetY, width: frame.width, height: frame.height)
        geometry.registerElement(with: frame)
        return attributes
    }
    
    fileprivate func buildLayoutAttributesForItem(at indexPath: IndexPath, geometry: AWMozaicLayoutSectionGeometry, matrix: AWMozaicLayoutSectionMatrix, additionalOffsetY: CGFloat) throws -> UICollectionViewLayoutAttributes {
        let itemSize = layoutCache.mozaikSizeForItem(atIndexPath: indexPath)
        let itemPosition = try matrix.positionForItem(of: itemSize)
        let itemGeometryFrame = geometry.frameForItem(withMozaikSize: itemSize, at: itemPosition)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: itemGeometryFrame.origin.x, y: itemGeometryFrame.origin.y + additionalOffsetY, width: itemGeometryFrame.width, height: itemGeometryFrame.height)
        geometry.registerElement(with: itemGeometryFrame)
        try matrix.addItem(of: itemSize, at: itemPosition)
        return attributes
        
    }
    
    fileprivate func buildUnionRectsFromLayoutAttributes(_ attributes: [UICollectionViewLayoutAttributes]) -> [CGRect] {
        var index = 0
        var unionRectsArray: [CGRect] = []
        let itemsCount = attributes.count
        while index < itemsCount {
            let frame1 = attributes[index].frame
            index = min(index + AWMozaicLayoutUnionSize, itemsCount) - 1
            let frame2 = attributes[index].frame
            unionRectsArray.append(frame1.union(frame2))
            index += 1
        }
        return unionRectsArray
    }
    
}
