//
//  ECGPlotApp.swift
//  ECGPlot
//
//  Created by Markus Schmid on 24.08.23.
//

import SwiftUI

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}

@main
struct ECGPlotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 300, height: 300)
        }
        .windowResizabilityContentSize()
        .commands {}
        
        WindowGroup("EKG Vorschau", id: "pdf-viewer", for: URL.self) { $url in
            if let url = url {
                PDFKitView(url: url)
                    .navigationTitle(url.lastPathComponent)
            }
        }
    }
}
