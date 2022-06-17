//
//  PicsParams.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

struct PicsParams: QueryParams {
    private static let minBlurLevel = 0
    private static let maxBlurLevel = 10
    let queryItems: [URLQueryItem]

    struct Size {
        let width: Int
        let height: Int
    }

    let size: Size
    let isGrayscale: Bool
    let blurLevel: Int

    init(extent: Int, isGrayscale: Bool = false, blurLevel: Int) {
        self.init(size: Size(width: extent, height: extent), isGrayscale: isGrayscale, blurLevel: blurLevel)
    }

    init(size: Size, isGrayscale: Bool = false, blurLevel: Int) {
        self.isGrayscale = isGrayscale
        self.size = size
        self.blurLevel = min(max(blurLevel, Self.minBlurLevel), Self.maxBlurLevel)
        self.queryItems = [
            URLQueryItem(name: "grayscale", value: nil),
            URLQueryItem(name: "blur", value: "\(blurLevel)"),
        ]
    }
}
