//
//  ScaledHeightImageView.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 17/06/2022.
//

import UIKit

class ScaledHeightImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        if let image = image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = frame.size.width

            let ratio = viewWidth/imageWidth
            let scaledHeight = imageHeight * ratio

            return CGSize(width: viewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
}
