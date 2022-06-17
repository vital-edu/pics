//
//  Collection+safeBounds.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 17/06/2022.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}
