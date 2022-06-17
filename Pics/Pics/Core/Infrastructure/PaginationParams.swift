//
//  PaginationParams.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

struct PaginationParams: QueryParams {
    let page: Int
    let limit: Int
    let queryItems: [URLQueryItem]

    init(page: Int, limit: Int = 10) {
        self.page = max(page, 0)
        self.limit = max(limit, 1)
        self.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
    }
}
