//
//  Coordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation

class Coordinator: NSObject {
    private(set) var childCoordinators = [Coordinator]()

    func start() {
        assertionFailure("This method needs to be overriden by concrete subclass.")
    }

    func finish() {
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

    func removeAllChildren<T: Coordinator>(of type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }

    func removeAllChildren() {
        childCoordinators.removeAll()
    }
}
