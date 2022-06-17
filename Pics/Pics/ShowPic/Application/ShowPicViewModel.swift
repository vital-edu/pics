//
//  ShowPicViewModel.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol ShowPicViewModelProtocol {
    // MARK: - Properties
    var pic: Dynamic<ShowPicViewDataType> { get }
    var effects: [Int: String] { get }
    var repository: PicsRepositoryProtocol { get }

    // MARK: - Events
    func changeEffect(to index: Int)
}

class ShowPicViewModel: ShowPicViewModelProtocol {
    let pic: Dynamic<ShowPicViewDataType>
    let repository: PicsRepositoryProtocol
    let effects: [Int: String] = [
        PicEffect.normal.rawValue: "Normal",
        PicEffect.blur.rawValue: "Blur",
        PicEffect.grayscale.rawValue: "Grayscale",
        PicEffect.blurAndGrayscale.rawValue: "Blur & Grayscale",
    ]

    init(pic: Pic, repository: PicsRepository) {
        self.pic = Dynamic(ShowPicViewData(
            pic: pic,
            width: pic.width,
            height: pic.height
        ))
        self.repository = repository
    }

    func changeEffect(to index: Int) {
        guard let oldPic = pic.value as? ShowPicViewData else { return }
        self.pic.value = oldPic.copyWith(effect: PicEffect(index))
    }
}
