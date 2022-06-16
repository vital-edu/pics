//
//  ListPicsCoordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation
import UIKit

class ListPicsCoordinator: Coordinator {
    weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController?) {
        self.rootViewController = rootViewController
    }

    override func start() {
        let apiClient = PicsApiClient()
        let remoteDataSource = PicsRemoteDataSource(apiClient: apiClient)
        let repository = PicsRepository(remoteDataSource: remoteDataSource)
        let viewModel = ListPicsViewModel(repository: repository)
        let viewController = ListPicsViewController()
        viewController.viewModel = viewModel
        rootViewController?.setViewControllers([viewController], animated: false)
    }

    override func finish() {
    }
}
