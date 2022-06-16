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
    let width: Double
    let height: Double
    let url: String
    let downloadIUrl: String
}
