//
//  ViewModel.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//
//

import SwiftUI


@MainActor
class ViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var urls: [URL] = []
    @Published var dallEImages: [DalleImage] = []
    @Published var fetching = false     //boolean property to monitor fetching process so we can then use it to prevent users from clicking on anything during fetching process
    
    @Published var selectedImage: UIImage?

    @Published var imageStyle = ImageStyle.none
    @Published var imageMedium = ImageMedium.none
    @Published var artist = Artist.none

    var description: String {
        let characterists = imageStyle.description + imageMedium.description + artist.description
        return prompt + (!characterists.isEmpty ? "\n- " + characterists : "")
    }
    

    let apiService = APIService()
    
    func clearProperties () {       //Clear out exsiting images upon opening the app
        urls = []
        dallEImages.removeAll()
        for _ in 1...Constants.n {
            dallEImages.append(DalleImage())
        }
        selectedImage = nil
    }

    func reset() {
        clearProperties()
        imageStyle = .none
        imageMedium = .none
        artist = .none
    }
    
    init() {
        clearProperties()
    }
    
    func fetchImages() {        //keep track of fetching state
        clearProperties()
        withAnimation {
            fetching.toggle()   //Fetching = true
        }
        let generationInput = GenerationInput(prompt: description)
        Task {
            if let data = generationInput.encodedData {
                do {
                    let response = try await apiService.fetchImages(with: data)
                    for data in response.data {
                        urls.append(data.url)    
                    }
                    withAnimation {
                        fetching.toggle()   //fetching = false
                    }

                    for (index, url) in urls.enumerated() {
                        dallEImages[index].uiImage = await apiService.loadImage(at: url)
                    }
                } catch {
                    print(error.localizedDescription)
                    fetching.toggle()
                }
            }
        }
    }
}
