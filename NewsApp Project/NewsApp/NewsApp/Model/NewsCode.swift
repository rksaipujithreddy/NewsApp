//
//  NewsCode.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import Foundation

struct NewsCode : Codable {
    let status  : String?
    let code    : String?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case status  = "status"
        case code    = "code"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status     = try values.decodeIfPresent(String.self, forKey: .status)
        code       = try values.decodeIfPresent(String.self, forKey: .code)
        message    = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
