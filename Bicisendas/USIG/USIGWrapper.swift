//
//  USIGWrapper.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import WebKit

import RxSwift
import RxCocoa


/// Wrapper for JS USIG services. This wrapper works by creating a hidden `WKWebView` that loads an HTML file
/// (`usig-api.html`). The API is then part Javascript (within `usig-api.html`) and part Swift, in this file.
/// Communication from Swift to Javascript is done by executing Javascript, while from Javascript to Swift is
/// done by `messageHandlers`.
class USIGWrapper: NSObject {

    /// Emits `true` when the API is ready.
    public var isReady = BehaviorRelay<Bool>(value: false)

    /// Receives a `String` with the search term to be send to USIG's API.
    public var searchTerm = PublishSubject<String>()

    /// Emits an array of `USIGContainer` objects with suggestions.
    /// Those objects are either `CalleDAO` or `DireccionDAO`.
    public var suggestions = BehaviorRelay<[USIGContainer]>(value: [])

    private let disposeBag = DisposeBag()


    /// Registered handlers in the `WKWebView`. Those should match what we trigger from `usig-api.html`.
    ///
    /// - ready: Triggered when the API is ready to be used.
    /// - suggestions: Triggered when there are new suggestions after a search.
    private enum USIGHandlers: String {
        case ready
        case suggestions
        case directions
        case debug // For debug purposes only
    }

    private var webView: WKWebView!

    private var ready = false {
        didSet {
            isReady.accept(ready)
        }
    }

    override init() {
        super.init()
        createWebView()
        createBindings()
    }

    private func createBindings() {
        searchTerm
            .subscribe(onNext: suggestions(for:))
            .disposed(by: disposeBag)
    }

    private func createWebView() {

        let data = try! Data(contentsOf: Bundle.main.url(forResource: "usig-api", withExtension: "html")!)

        let userContentController = WKUserContentController()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        userContentController.add(self, name: USIGHandlers.ready.rawValue)
        userContentController.add(self, name: USIGHandlers.suggestions.rawValue)
        userContentController.add(self, name: USIGHandlers.directions.rawValue)
        userContentController.add(self, name: USIGHandlers.debug.rawValue)

        self.webView = WKWebView(frame: CGRect.zero, configuration: configuration)

        webView.load(data,
                     mimeType: "text/html",
                     characterEncodingName: "UTF8",
                     baseURL: URL(string: "http://servicios.usig.buenosaires.gob.ar/usig-js/3.2/demos/")!)
    }

    public func suggestions(for inputString: String) {
        webView.evaluateJavaScript("api.getSuggestions(\"\(inputString)\")") { (_, error) in
        }
    }

    public func directions(from: USIGContainer, to: USIGContainer) {
        let jsonEncoder = JSONEncoder()

        let fromJSON = try! jsonEncoder.encode(from)
        let toJSON = try! jsonEncoder.encode(to)

        guard
            let fromString = String(data: fromJSON, encoding: .utf8),
            let toString = String(data: toJSON, encoding: .utf8)
        else { return }

        webView.evaluateJavaScript("api.getDirections(\(fromString), \(toString))") { (_, error) in
            if let error = error {
                print("👍 👎 Error executing Javascript - \(error)")
            }
        }
    }

}

extension USIGWrapper: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case USIGHandlers.ready.rawValue:
            ready = true
        case USIGHandlers.suggestions.rawValue:
            let decoder = JSONDecoder()
            if let dataString = message.body as? String, let data = dataString.data(using: .utf8) {

                let elements = try! decoder.decode([USIGContainer].self, from: data)

                suggestions.accept(elements)
            }
        case USIGHandlers.directions.rawValue:
            print("👍 got directions")
        case USIGHandlers.debug.rawValue:
            print("👍 usig-api DEBUG \(message.body)")
        default:
            print("👍 default case in \(#function)")
        }
    }

}
