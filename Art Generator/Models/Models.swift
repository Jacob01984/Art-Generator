//
//  Models.swift
//  Art Generator
//
//  Created by Jacob Lavenant on 3/11/23.
//
//2️⃣

import SwiftUI

enum Constants {
    static let imageSize = "256x256"  //generated image size
    static let n = 4                //number of images created
}

struct GenerationInput: Codable {
    var prompt: String
    var n = Constants.n
    var size = Constants.imageSize
    
    var encodedData: Data? {        //encoding data for submission to API
        try? JSONEncoder().encode(self)
    }
}
//struct that stores generated images for a array 3️⃣
struct DalleImage: Identifiable {
    var id = UUID()
    var uiImage: UIImage?       //each image will be nil til we retrieve from api
}

struct ResponseModel: Codable {     //Decode response data from the API
    struct Data: Codable {
        let url: URL
    }
    let created: Date
    let data: [Data]
}
