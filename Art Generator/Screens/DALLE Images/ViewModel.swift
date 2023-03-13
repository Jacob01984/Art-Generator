//
//  ViewModel.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//
//5️⃣

import SwiftUI


@MainActor      //we need to update the ui due to the calls to the api
class ViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var urls: [URL] = []     //array of urls generated from api
    @Published var dallEImages: [DalleImage] = []       //fetch images from urls and update array of generated images [DallEImage]
    @Published var fetching = false     //boolean property to monitor fetching process so we can then use it to prevent users from clicking on anything during fetching process
    
    let apiService = APIService()       //instance of APIService
    
    func clearProperties () {       //Clear out exsiting images upon opening the app
        urls = []
        dallEImages.removeAll()     //removes images from dallEImages which has the DalleImage array
        for _ in 1...Constants.n {
            dallEImages.append(DalleImage())
        }
    }       //initializer that declares clearProperties func
    init() {
        clearProperties()
    }
    func fetchImages() {        //keep track of fetching state
        clearProperties()
        withAnimation {
            fetching.toggle()   //Fetching = true
        }
        let generationInput = GenerationInput(prompt: prompt)   //New GenerationInput passing the prompt
        Task {
            if let data = generationInput.encodedData {     //use if let to see if we get data from generationInput objects
                do {
                    let response = try await apiService.fetchImages(with: data)     //let response be the result of trying and awaiting the call to the api
                    for data in response.data {     //response.data is the array of objects that has a url property
                        urls.append(data.url)    //append each URL property to the URL's array
                    }
                    withAnimation {
                        fetching.toggle()   //fetching = false
                    }
//6️⃣ after fetching we will retrieve all the images
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
