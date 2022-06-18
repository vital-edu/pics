//
//  BasePageViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import UIKit

class BasePageViewController: UIPageViewController, Deinitcallable {
    var onDeinit: (() -> Void)?

    deinit {
        onDeinit?()
    }
}
