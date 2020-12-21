//
//  File.swift
//  
//
//  Created by Adam Wienconek on 21/12/2020.
//

import UIKit

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(left)
        hasher.combine(bottom)
        hasher.combine(right)
        hasher.combine(top)
    }
}
