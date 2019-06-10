//
//  Environment.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 10/06/2019.
//  Copyright © 2019 Igor Kulman. All rights reserved.
//

import FeedKit
import Foundation
import os.log
import UIKit

struct Environment {
    var settings = Settings()
    var feed = Feed()
    var version = Version()
    var storyboards = Storyboards()
    var appData = AppData()
}

var Current = Environment()

struct AppData {
    var loadFile = { (fileName: String) -> Data? in
        let parts = fileName.components(separatedBy: ".")
        if let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1]), let data = try? Data(contentsOf: url) {
            return data
        } else {
            return nil
        }
    }
}

struct Version {
    var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
    var appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    var appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
}

struct Settings {
    var getSelectedSource = { () -> RssSource? in
        let coder = JSONDecoder()
        guard let value = UserDefaults.standard.data(forKey: "source"), let source = try? coder.decode(RssSource.self, from: value) else {
            return nil
        }

        return source
    }

    var setSelectedSource = { (source: RssSource?) in
        guard let value = source else {
            UserDefaults.standard.removeObject(forKey: "source")
            return
        }

        let coder = JSONEncoder()
        guard let data = try? coder.encode(value) else {
            fatalError("Encoding RssSource should never fail")
        }

        UserDefaults.standard.set(data, forKey: "source")
    }
}

enum RssError: Error, CustomStringConvertible {
    case badUrl

    var description: String {
        switch self {
        case .badUrl:
            return L10n.badUrl
        }
    }
}

enum RssResult {
    case failure(Error)
    case success([RssItem])
}

struct Feed {
    var get = { (source: RssSource, onCompletion: @escaping (RssResult) -> Void) in
        guard let feedURL = URL(string: source.rss) else {
            onCompletion(.failure(RssError.badUrl))
            return
        }

        let parser = FeedParser(URL: feedURL)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        os_log("Loading %@", log: OSLog.data, type: .debug, feedURL.absoluteString)

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            if let error = result.error {
                os_log("Loading data failed with %@", log: OSLog.data, type: .error, error)
                onCompletion(.failure(error))
            } else if let rss = result.rssFeed, let items = rss.items {
                onCompletion(.success(items.map({ RssItem(title: $0.title, description: $0.description, link: $0.link, pubDate: $0.pubDate) })))
            } else {
                onCompletion(.success([]))
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}

struct Storyboards {
    func createViewController<ViewController: StoryboardLodable>(_ serviceType: ViewController.Type) -> ViewController {
        let storyboard = UIStoryboard(name: serviceType.storyboardName, bundle: nil)
        let name = "\(serviceType)".replacingOccurrences(of: "ViewController", with: "")
        let controller = storyboard.instantiateViewController(withIdentifier: name)
        return controller as! ViewController
    }
}
