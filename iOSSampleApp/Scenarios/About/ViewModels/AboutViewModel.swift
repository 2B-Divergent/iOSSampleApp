//
//  AboutViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

final class AboutViewModel {

    let appName: String
    let appVersion: String

    init() {
        appName = Current.version.appName
        appVersion = "\(Current.version.appVersion) (\(Current.version.appBuild))"
    }
}
