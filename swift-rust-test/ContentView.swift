//
//  ContentView.swift
//  swift-rust-test
//
//  Created by Markus Stenberg on 4.10.2024.
//

import SwiftUI

class SwiftResultHandler: NSObject, ResultHandler {
    var view: ContentView

    init(_ view: ContentView) {
        self.view = view
    }

    func error(err: String) {
        view.text = "Rust error occurred: \(err)"
    }

    func result(s: String) {
        view.text = "Rust result: \(s)"
    }
}

struct ContentView: View {
    @State var text = "Nothing fetched, yet"
    var body: some View {
        VStack {
            Text(text)
            Button("Fetch something") {
                print("Fetch started..")
                let rh = SwiftResultHandler(self)
                let backend = Backend(rh: rh)
                // NB: This renaming of methods is weird default (fetch_url=>)
                backend.fetchUrl(url: "https://fingon.kapsi.fi")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
