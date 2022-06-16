//
//  ListPicViewData.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

protocol ListPicViewDataType {
    var id: String { get }
    var imageUrl: URL? { get }
    var size: CGSize { get }
}

struct ListPicViewData: ListPicViewDataType {
    private let utils = PicUtils()
    let pic: Pic
    let imageUrl: URL?
    let size: CGSize
    var id: String { pic.id }

    init(pic: Pic, width: Int) {
        self.pic = pic
        imageUrl = utils.getPicUrl(imageId: pic.id, width: width, height: width)
        size = CGSize(width: width, height: width)
    }
}
