//
//  ShowPicViewModel.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol ShowPicViewModelProtocol {
    // MARK: - Properties

    var pic: ShowPicViewDataType { get }
    var repository: PicsRepositoryProtocol { get }

    // MARK: - Events
}

class ShowPicViewModel: ShowPicViewModelProtocol {
    let pic: ShowPicViewDataType
    let repository: PicsRepositoryProtocol

    init(pic: Pic, repository: PicsRepository) {
        self.pic = ShowPicViewData(
            pic: pic,
            width: pic.width,
            height: pic.height
        )
        self.repository = repository
    }
}
