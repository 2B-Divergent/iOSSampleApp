//
//  FeedViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 16/09/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest

class FeedViewModelTests: QuickSpec {
    override func spec() {
        describe("FeedViewModel") {
            let getFeed = Current.feed.get
            let getSelectedSource = Current.settings.getSelectedSource

            beforeEach {
                Current.settings.getSelectedSource = {
                    return RssSource(title: "Coding Journal", url: "https://blog.kulman.sk", rss: "https://blog.kulman.sk/index.xml", icon: nil)
                }
                Current.feed.get = { _, onCompletion in
                    onCompletion(.success([RssItem(title: "Test 1", description: nil, link: nil, pubDate: nil), RssItem(title: "Test 2", description: nil, link: nil, pubDate: nil)]))
                }
            }

            afterEach {
                Current.feed.get = getFeed
                Current.settings.getSelectedSource = getSelectedSource
            }

            context("when initialized") {
                it("should load RSS items") {
                    let vm = FeedViewModel()
                    let feed = try! vm.feed.toBlocking().first()!
                    expect(feed.count) == 2
                }
            }
        }
    }
}
