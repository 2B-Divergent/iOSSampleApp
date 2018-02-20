//
//  SettingsService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 20/02/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

protocol SettingsService: class {
    var selectedSource: RssSource? { get set }
}
