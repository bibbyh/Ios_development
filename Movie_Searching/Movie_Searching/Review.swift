//
//  Review.swift
//  lab4
//
//  Created by 衡俊吉 on 10/22/18.
//  Copyright © 2018 junji. All rights reserved.
//

import Foundation

struct Review: Codable {
    
    var results: [Comments]?
    
    struct Comments: Codable {
        var author: String?
        var content: String?
 
        
        enum Comments: String, CodingKey
        {
            case author = "author"
            case content = "content"
        }
        
    }
    
    
}
