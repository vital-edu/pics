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
    var selectedEffect: Int { get }
}

struct ShowPicViewData: ShowPicViewDataType {
    let pic: Pic
    let imageUrl: URL?
    let utils = PicUtils(baseUrl: PicsApiClient.baseUrl)
    let selectedEffect: Int

    var title: String { pic.author }

    init(pic: Pic, width: Int, height: Int, effect: PicEffect = .normal) {
        self.pic = pic
        self.selectedEffect = effect.rawValue
        self.imageUrl = utils.getPicUrl(
            imageId: pic.id,
            width: width,
            height: height,
            effect: effect
        )
    }

    func copyWith(effect: PicEffect) -> ShowPicViewData {
        return Self.init(
            pic: self.pic,
            width: pic.width,
            height: pic.height,
            effect: effect
        )
    }
}
