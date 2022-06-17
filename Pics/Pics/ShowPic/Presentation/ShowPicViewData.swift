//
//  ShowPicViewData.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol ShowPicViewDataType {
    var title: String { get }
    var imageUrl: URL? { get }
}

struct ShowPicViewData: ShowPicViewDataType {
    let pic: Pic
    let imageUrl: URL?
    let utils = PicUtils(baseUrl: PicsApiClient.baseUrl)

    var title: String { pic.author }

    init(pic: Pic, width: Int, height: Int) {
        self.pic = pic
        self.imageUrl = utils.getPicUrl(
            imageId: pic.id,
            width: width,
            height: height
        )
    }
}
