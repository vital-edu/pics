//
//  ShowPicCoordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

class ShowPicCoordinator: Coordinator {
    private let pic: Pic
    private weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController?, pic: Pic) {
        self.rootViewController = rootViewController
        self.pic = pic
    }

    override func start() {
        let apiClient = PicsApiClient()
        let remoteDataSource = PicsRemoteDataSource(apiClient: apiClient)
        let repository = PicsRepository(remoteDataSource: remoteDataSource)
        let viewModel = ShowPicViewModel(pic: pic, repository: repository)
        let viewController = ShowPicViewController()
        viewController.viewModel = viewModel

        setDeallocallable(with: viewController)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}
