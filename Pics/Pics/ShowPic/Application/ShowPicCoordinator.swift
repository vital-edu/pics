//
//  ShowPicCoordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

class ShowPicCoordinator: Coordinator {
    private let picId: String
    private weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController?, picId: String) {
        self.rootViewController = rootViewController
        self.picId = picId
    }

    override func start() {
        let viewController = ShowPicViewController()

        setDeallocallable(with: viewController)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}
