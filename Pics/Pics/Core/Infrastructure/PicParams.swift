//
//  PicParams.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

struct PicParams: QueryParams {
    let queryItems: [URLQueryItem]

    struct Size {
        let width: Int
        let height: Int
    }

    let size: Size
    let isGrayscale: Bool
    let isBlur: Bool

    init(extent: Int, isGrayscale: Bool = false, isBlur: Bool) {
        self.init(size: Size(width: extent, height: extent), isGrayscale: isGrayscale, isBlur: isBlur)
    }

    init(size: Size, isGrayscale: Bool = false, isBlur: Bool) {
        self.isGrayscale = isGrayscale
        self.size = size
        self.isBlur = isBlur
        self.queryItems = [
            URLQueryItem(name: "grayscale", value: nil),
            URLQueryItem(name: "blur", value: nil),
        ]
    }
}
