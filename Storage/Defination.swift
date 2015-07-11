//
//  Defination.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation

//MARK: - Defination

public protocol Identifierable{
    var id:String { get }
}

public typealias Dictionariable = protocol<Equatable, Identifierable>

public enum StorageExtendObjectsPosition{
    case Leading
    case Tail
}

public func == (lhs:Identifierable, rhs:Identifierable)->Bool{
    return lhs.id == rhs.id
}