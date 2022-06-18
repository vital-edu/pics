//
//  PicPreviewViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import UIKit

class PicPreviewViewController: UIViewController {
    var image: UIImage? {
        get { (view as? UIImageView)?.image }
        set {
            (view as? UIImageView)?.image = newValue
        }
    }

    override func loadView() {
        self.view = UIImageView()
    }
}
