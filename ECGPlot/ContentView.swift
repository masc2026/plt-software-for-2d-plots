//
//  ContentView.swift
//  ECGPlot
//
//  Created by Markus Schmid on 24.08.23.
//

import Foundation
import SwiftUI
import Cocoa
import UniformTypeIdentifiers
import PDFKit

extension UTType {
    static var customMAT: UTType {
        UTType(importedAs: "com.mascapp.mat-file")
    }
}

struct PDFKitView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
}

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var inputFilePath: URL?
    @State private var outputFilePath: URL?
    @State private var progress: Progress?
    @State private var showingAlert = false
    @State private var generatedPDFURL: URL?

    var body: some View {
        VStack {
            HStack {
                Button("Run", action: runFunction)
                Button("Demo", action: {
                    showingAlert = true
                })
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Info"),
                        message: Text("Noch nichts zu sehen"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            if let progress = progress {
                ProgressView(progress)
            }
        }.padding()
    }

    func demoFunction() {
        progress = Progress(totalUnitCount: 1)
        let backgroundQueue = DispatchQueue.global(qos: .background)

        backgroundQueue.async {
            for i in 1...1 {
                if let scriptPath = Bundle.main.url(forResource: "macdemo", withExtension:"zsh") {
                    let process = Process()
                    let pipe = Pipe()
                    process.standardOutput = pipe
                    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    var environment =  ProcessInfo.processInfo.environment
                    environment["BINDIR"] = Bundle.main.bundlePath+"/Contents/MacOS";
                    process.environment = environment
                    process.arguments = ["-c", "source \(scriptPath.path)"]
                    process.launch()
                    process.waitUntilExit()
                }
                Thread.sleep(forTimeInterval: 0.1)
                progress?.completedUnitCount = Int64(i)
            }
            DispatchQueue.main.async {
                progress = nil
            }
        }
    }
    
    func runFunction() {
        let tempDir = FileManager.default.temporaryDirectory
        let finalPDFURL = tempDir.appendingPathComponent("ECG_Preview_\(Date().timeIntervalSince1970).pdf")
        let destinationPath = finalPDFURL.path
        
        progress = Progress(totalUnitCount: 1)
        let backgroundQueue = DispatchQueue.global(qos: .background)
            
        backgroundQueue.async {
            guard let appBundleURL = Bundle.main.bundleURL.deletingLastPathComponent() as URL?,
                  let binDirURL = Bundle.main.executableURL?.deletingLastPathComponent(),
                  let matPath = Bundle.main.path(forResource: "JS00001", ofType: "mat") else { return }

            let scriptsDirURL = appBundleURL.appendingPathComponent("bin")
            
            let process = Process()
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe

            process.executableURL = URL(fileURLWithPath: "/bin/zsh")

            var environment = ProcessInfo.processInfo.environment

            let currentPath = environment["PATH"] ?? "/usr/bin:/bin:/usr/sbin:/sbin"
            environment["PATH"] = "/opt/homebrew/bin:/usr/local/bin:\(currentPath)"
            environment["PATH"] = "\(scriptsDirURL.path()):\(environment["PATH"] ?? "")"
            environment["BINDIR"] = binDirURL.path

            process.environment = environment
          
            let shellCommand = """
                ( \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.050 0.990 0.104 -g grid,sub -cz 0 .002 -F"p 0,1n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.129 0.990 0.183 -g grid,sub -cz 0 .002 -F"p 0,2n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.208 0.990 0.261 -g grid,sub -cz 0 .002 -F"p 0,3n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.286 0.990 0.340 -g grid,sub -cz 0 .002 -F"p 0,4n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -Y -500 500 -W 0.020 0.365 0.990 0.419 -g grid,sub -cz 0 .002 -F"p 0,5n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.444 0.990 0.498 -g grid,sub -cz 0 .002 -F"p 0,6n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.523 0.990 0.576 -g grid,sub -cz 0 .002 -F"p 0,7n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.601 0.990 0.655 -g grid,sub -cz 0 .002 -F"p 0,8n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.680 0.990 0.734 -g grid,sub -cz 0 .002 -F"p 0,9n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.759 0.990 0.813 -g grid,sub -cz 0 .002 -F"p 0,10n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -Y -1000 1200 -W 0.020 0.838 0.990 0.891 -g grid,sub -cz 0 .002 -F"p 0,11n(Cred)"; \
                plt -st -T lw :s12,0000,5000,1 "\(matPath)" -W 0.020 0.916 0.990 0.970 -g grid,sub -cz 0 .002 -F"p 0,12n(Cred)" \
                ) | lwcat -custom 50 20 0 0 1 -pstopdf > "\(destinationPath)"
                """
            
            process.arguments = ["-c", shellCommand]
            
            do {
                try process.run()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    print("Shell Feedback/Errors:\n\(output)")
                }
                
                process.waitUntilExit()
                DispatchQueue.main.async {
                    self.progress?.completedUnitCount = 1
                    self.progress = nil
                    openWindow(id: "pdf-viewer", value: finalPDFURL)
                }
                
            } catch {
                print("Fehler beim Starten: \(error)")
                DispatchQueue.main.async { self.progress = nil }
            }
        }
    }
}
