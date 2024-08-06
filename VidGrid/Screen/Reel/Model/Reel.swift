//
//  Reel.swift
//  VidGrid
//
//  Created by iMac on 05/08/24.
//

import Foundation

// MARK: - Reels
struct ReelsResponse: Codable {
    let reels: [Reel]
}

// MARK: - Reel
struct Reel: Codable {
    let arr: [Video]
}

// MARK: - Video
struct Video: Codable {
    let id: String
    let video: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video, thumbnail
    }
}
