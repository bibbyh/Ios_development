//
//  Latest.swift
//  lab4
//
//  Created by 衡俊吉 on 10/22/18.
//  Copyright © 2018 junji. All rights reserved.
//

import Foundation

struct Latest: Decodable {
    
    let id: Int!
    let poster_path: String?
    let title: String
    let original_language: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    
    
    
}
