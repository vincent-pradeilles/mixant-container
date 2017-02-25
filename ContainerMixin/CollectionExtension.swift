//
//  CollectionExtension.swift
//  ContainerMixin
//
//  Created by Vincent on 25/02/2017.
//  Copyright © 2017 Vincent Pradeilles. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
