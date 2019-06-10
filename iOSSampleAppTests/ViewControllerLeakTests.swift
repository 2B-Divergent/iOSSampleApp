//
//  ViewControllerLeakTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 26/11/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import XCTest

class ViewControllerLeakTests: QuickSpec {
    override func spec() {
        describe("AboutViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return Current.storyboards.createViewController(AboutViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("LibrariesViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return Current.storyboards.createViewController(LibrariesViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("FeedViewController") {
            var getSelectedSource = Current.settings.getSelectedSource
            var getFeed = Current.feed.get

            beforeEach {
                getSelectedSource = Current.settings.getSelectedSource
                Current.settings.getSelectedSource = {
                    return RssSource(title: "Test", url: "https://blog.kulman.sk", rss: "https://blog.kulman.sk/index.xml", icon: nil)
                }
                getFeed = Current.feed.get
                Current.feed.get = { _, onCompletion in
                    onCompletion(.success([]))
                }
            }

            afterEach {
                Current.settings.getSelectedSource = getSelectedSource
                Current.feed.get = getFeed
            }

            describe("viewDidLoad") {
                let vc = LeakTest {
                    return Current.storyboards.createViewController(FeedViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("DetailViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return DetailViewController(item: RssItem(title: "Test", description: "Test sesc", link: "https://blog.kulman.sk", pubDate: Date()))
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("CustomSourceViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return Current.storyboards.createViewController(CustomSourceViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("SourceSelectionViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return Current.storyboards.createViewController(SourceSelectionViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }
    }
}
