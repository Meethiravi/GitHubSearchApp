//
//  Repository.swift
//  SearchGitHub
//
//  Created by Mahalakshmi Raveenthiran on 01/07/21.
//

import Foundation

struct RepositoryData: Codable {
    var total_count : Int?
    var incomplete_results : Bool?
    var items: [Item]
}

//struct ItemResponse: Codable {
//    var items: [Item]?
//}

struct Item: Codable {
    
    var full_name: String?
    var owner: Owner?
    var html_url: String?
    var description: String?
    
}

struct Owner: Codable {
    var login: String?
    var avatar_url: String?
}

//enum CodingKeys: String, CodingKey {
//
//    case items = "items"
//    case full_name = "full_name"
//    case owner = "owner"
//    case login = "login"
//    case avatar_url = "avatar_url"
//    case description = "description"
//
//
//}
