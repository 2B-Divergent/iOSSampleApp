//
//  RssSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift

class RssSourceViewModel {
    let source: RssSource
    let isSelected = Variable<Bool>(false)
    
    init(source: RssSource) {
        self.source = source
    }
}
