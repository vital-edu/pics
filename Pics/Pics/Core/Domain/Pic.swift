//
//  Pic.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation

struct Pic: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url, downloadUrl = "download_url"
    }
}
