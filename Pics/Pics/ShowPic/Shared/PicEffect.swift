//
//  PicEffect.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

enum PicEffect: Int, QueryParams {
    case normal, blur, grayscale, blurAndGrayscale

    var queryItems: [URLQueryItem] {
        switch self {
        case .normal:
            return []
        case .blur:
            return [URLQueryItem(name: "blur", value: nil)]
        case .grayscale:
            return [URLQueryItem(name: "grayscale", value: nil)]
        case .blurAndGrayscale:
            return [
                URLQueryItem(name: "blur", value: nil),
                URLQueryItem(name: "grayscale", value: nil)
            ]
        }
    }

    init(_ index: Int) {
        switch index {
        case 0:
            self = .normal
        case 1:
            self = .blur
        case 2:
            self = .grayscale
        case 3:
            self = .blurAndGrayscale
        default:
            self = .normal
        }
    }
}
