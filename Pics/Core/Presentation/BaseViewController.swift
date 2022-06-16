//
//  BaseViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

class BaseViewController: UIViewController, Deinitcallable {
    var onDeinit: (() -> Void)?

    deinit {
        onDeinit?()
    }
}
