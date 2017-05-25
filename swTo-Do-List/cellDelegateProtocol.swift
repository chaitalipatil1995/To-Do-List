//
//  cellDelegateProtocol.swift
//  swTo-Do-List
//
//  Created by Amesten Systems on 24/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import Foundation

//protocol cellDelegateProtocol {
//    
//    func didPressButton(_ tag: NSInteger)
//
//}

protocol cellDelegateProtocol: class {
    func didPressButton(_ tag: NSInteger)
}

class SomeClass {
    weak var delegate: cellDelegateProtocol?
}
