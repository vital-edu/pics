//
//  Dynamic.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

class Dynamic<Type> {
    typealias Listener = (Type) -> ()

    private var listener: Listener?
    var value: Type {
        didSet {
            listener?(value)
        }
    }

    init(_ value: Type) {
        self.value = value
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        bind(listener)
        listener?(value)
    }
}

