//
//  Art_GeneratorApp.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        let sample = GenerationInput(prompt: "Man in a ford mustang driving in a storm similar to work by Van Gogh")
                        if let data = sample.encodedData {
                            try await  APIService().fetchImages(with: data)
                        }
                    }
                }
        }
    }
}
