//
//  Coordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation

class Coordinator: NSObject, CoordinatorProtocol {
    var finish: (() -> Void)?
    weak var deallocallable: Deinitcallable?

    private(set) var childCoordinators = [Coordinator]()

    func start() {
        assertionFailure("This method needs to be overriden by concrete subclass.")
    }

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(of: coordinator) else {
            return
        }
        childCoordinators.remove(at: index)
    }

    func removeAllChildren() {
        childCoordinators.removeAll()
    }
}
