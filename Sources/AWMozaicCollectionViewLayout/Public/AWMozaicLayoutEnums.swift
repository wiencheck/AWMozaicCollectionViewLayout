//
//  AWMozaicLayoutEnums.swift
//  AWMozaicCollectionViewLayout
//
//  Created by Adam Wienconek on 7/17/18.
//  Copyright © 2018 Adam Wienconek. All rights reserved.
//

import Foundation

/**
 *  Defines the layout's content mode
 */
public enum AWMozaicLayoutSectionContentMode {
    /**
     * Try to fill all vacant spaces for the cell
     * Default value
     */
    case fill
    
    /**
     * Keep the order for cells, so even if there is a vacant space somewhere before last cell don't use it
     */
    case ordered
}
