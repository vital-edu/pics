//
//  CoordinatorProtocol.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    func start()
    func setDeallocallable(with object: Deinitcallable)

    var finish: (() -> Void)? { get set }
    var deallocallable: Deinitcallable? { get set }
}

extension CoordinatorProtocol {
    func setDeallocallable(with object: Deinitcallable) {
        deallocallable?.onDeinit = nil
        object.onDeinit = { [weak self] in
            self?.finish?()
        }
        deallocallable = object
    }
}
