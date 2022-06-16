//
//  ListPicViewData.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol ListPicViewDataType {
    var imageUrl: URL? { get }
}

struct ListPicViewData: ListPicViewDataType {
    private let utils = PicUtils()
    let pic: Pic
    let imageUrl: URL?

    init(pic: Pic, width: Int) {
        self.pic = pic
        imageUrl = utils.getPicUrl(imageId: pic.id, width: width, height: width)
    }
}
