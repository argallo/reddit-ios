//
//  Listing.swift
//  reddit
//
//  Created by Anthony Gallo on 3/19/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation

/* Decodables are great! */
struct Listing : Decodable {
    let data: ListingData
}

struct ListingData : Decodable {
    let children: [ListingChild]
}

struct ListingChild : Decodable{
    let kind: String
    let data: ListingChildData
}

struct ListingChildData : Decodable {
    let name: String //Name is used for making page requests
    let title: String // Title of post
    let ups: Int64? //Number of likes
    let num_comments: Int64? //Comments *int64 cause last thing we need is an overflow on iphone 5 :)
    let thumbnail: String? //URLString for thumbnail
    let url: String?
}
