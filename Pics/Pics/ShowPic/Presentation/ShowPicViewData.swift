//
//  ShowPicViewData.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

protocol ShowPicViewDataType {
    var id: String { get }
    var title: String { get }
    var author: String { get }
    var size: NSAttributedString { get }
    var url: URL? { get }
    var downloadUrl: NSAttributedString { get }
    var selectedEffect: Int { get }
}

struct ShowPicViewData: ShowPicViewDataType {
    let pic: Pic
    let url: URL?
    let utils = PicUtils(baseUrl: PicsApiClient.baseUrl)
    let selectedEffect: Int

    let id: String
    let author: String
    let size: NSAttributedString
    let downloadUrl: NSAttributedString

    var title: String { pic.author }

    init(pic: Pic, width: Int, height: Int, effect: PicEffect = .normal) {
        self.pic = pic
        self.selectedEffect = effect.rawValue
        self.id = pic.id
        self.author = pic.author
        self.size = NSMutableAttributedString()
            .bold("Size: ")
            .normal("\(pic.width)x\(pic.height)")
        self.downloadUrl = NSMutableAttributedString()
            .bold("Download URL: ")
            .normal(pic.downloadUrl)

        self.url = utils.getPicUrl(
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
