//
//  QueryParams.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol QueryParams {
    var queryItems: [URLQueryItem] { get }
}
