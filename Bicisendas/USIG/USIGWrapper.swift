//
//  USIGWrapper.swift
//  Bicisendas
//
//  Created by Pablo Bendersky on 27/08/2018.
//  Copyright © 2018 Pablo Bendersky. All rights reserved.
//

import WebKit

class USIGWrapper: NSObject {

    private enum USIGHandlers: String {
        case ready
        case suggestions
    }

    private var webView: WKWebView!

    private var ready = false

    override init() {
        super.init()
        createWebView()
    }

    private func createWebView() {

        let data = try! Data(contentsOf: Bundle.main.url(forResource: "usig-api", withExtension: "html")!)

        let userContentController = WKUserContentController()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        userContentController.add(self, name: USIGHandlers.ready.rawValue)
        userContentController.add(self, name: USIGHandlers.suggestions.rawValue)

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

}

extension USIGWrapper: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case USIGHandlers.ready.rawValue:
            ready = true
        case USIGHandlers.suggestions.rawValue:
            let decoder = JSONDecoder()
            let data = message.body as! Data
            decoder.decode([Suggestion].self, from: data)
        default:
            print("👍 default case in \(#function)")
        }
        print("👍 \(message.name)")
        print("👍 \(message.body)")
    }

}
