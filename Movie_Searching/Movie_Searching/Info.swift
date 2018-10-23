//
//  Info.swift
//  InClassDemo2
//
//  Created by Todd Sproull on 10/8/18.
//  Copyright © 2018 Todd Sproull. All rights reserved.
//

import Foundation

struct Info: Codable {

    var results: [Movies]?
    
    struct Movies: Codable {
        var vote_count: Int?
        var id: Int?
        var adult: Bool?
        var overview: String?
        var release_date: String?
        var original_title: String?
        var poster_path: String?
        var original_language: String?
        var title: String?
        var backdrop_path: String?
        var popularity: Double?
        var video: Bool?
        var vote_average: Double?

        enum Movies: String, CodingKey
        {
            case vote_count = "vote_count"
            case id = "id"
            case adult = "adult"
            case overview = "overview"
            case release_date = "release_date"
            case original_title = "original_title"
            case poster_path = "poster_path"
            case original_language = "original_language"
            case title = "title"
            case backdrop_path = "backdrop_path"
            case popularity = "popularity"
            case video = "video"
            case vote_average = "vote_average"
        }

    }

    
}
