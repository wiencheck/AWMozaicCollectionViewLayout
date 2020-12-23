//
//  AWMozaicLayoutStructs.swift
//  AWMozaicCollectionViewLayout
//
//  Created by Adam Wienconek on 16/05/20.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

/**
 *  Defines the structure to identify the position of the layout item
 */
public struct AWMozaicLayoutPosition: Hashable {
    /// Column number of the item's position
    let column: Int
    /// Row number of the item's position
    let row: Int
    /// Section number of the item's
    let section: Int
    
    ///
    /// Designated initializer for structure
    ///
    /// - Parameter column: column number
    /// - Parameter row:    roe number
    ///
    /// - Returns: newly created `AWMozaicLayoutPosition`
    public init(atColumn column: Int, atRow row: Int, inSection section: Int) {
        self.column = column
        self.row = row
        self.section = section
    }
}

/**
 *  Defines the size of the layout item
 */
public struct AWMozaicLayoutSize: Hashable {
    /// Columns number that item requires
    let columns: Int
    /// Rows number that item requires
    let rows: Int
    
    ///
    /// Designated initializer for structure
    ///
    /// - Parameter columns: number of colums (basically the width)
    /// - Parameter rows:    number of rows (basically the height)
    ///
    /// - Returns: newly created `AWMozaicLayoutSize`
    public init(numberOfColumns columns: Int, numberOfRows rows: Int) {
        self.columns = columns
        self.rows = rows
    }
    
    ///
    /// Calculates number of total cells in mozaik layout that item fills
    ///
    /// - Returns: number of required mozaik cells for item
    public func totalCells() -> Int {
        return self.columns * self.rows
    }
}

/**
 *  Defines the layout's column
 */
public struct AWMozaicLayoutColumn: Hashable {
    /// Width of the column in points
    let width: CGFloat
    
    ///
    /// Designated initializer for structure
    ///
    /// - Parameter width: column's width in points
    ///
    /// - Returns: newly created `AWMozaicLayoutColumn`
    public init(width: CGFloat) {
        self.width = width
    }
}

/**
 *  Defines the layout's information
 */
public struct AWMozaicLayoutSectionGeometryInfo: Hashable {
    /// array of `AWMozaicLayoutColumn` for the layout
    let columns: [AWMozaicLayoutColumn]
    
    /// height for each row in points
    let rowHeight: CGFloat
    
    /// minimum space between items
    let minimumInteritemSpacing: CGFloat
    
    /// minimum space between each row
    let minimumLineSpacing: CGFloat
    
    /// Insets for the section from top, left, right, bottom
    let sectionInset: UIEdgeInsets
    
    /// Height for header in section
    /// Width is currently limited to the collection view width
    let headerHeight: CGFloat
    
    /// Height for footer in section
    /// Width is currently limited to the collection view width
    let footerHeight: CGFloat
    
    ///
    /// Designated initializer for structure
    ///
    /// - Parameter rowHeight:               height for each row in points
    /// - Parameter columns:                 array of `AWMozaicLayoutColumn` for the layout
    /// - Parameter minimumInteritemSpacing: minimum space between items
    /// - Parameter minimumLineSpacing:      minimum space between each row
    ///
    /// - Returns: newly created `AWMozaicLayoutColumn`
    public init(rowHeight: CGFloat, columns: [AWMozaicLayoutColumn], minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = UIEdgeInsets.zero, headerHeight: CGFloat = 0, footerHeight: CGFloat = 0) {
        self.columns = columns
        self.rowHeight = rowHeight
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
    }
    
    ///
    /// Checks whether the geometry info is valid
    ///
    /// - Returns: true if the info has non zero columns number and non zero rowHeight
    public func isValid() -> Bool {
        return self.columns.count > 0 && self.rowHeight > 0
    }
}
