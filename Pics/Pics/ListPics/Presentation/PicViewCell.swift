//
//  PicViewCell.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit
import Kingfisher

class PicViewCell: UICollectionViewCell {
    static let identifer = "PicCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    private var imageUrl: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true

        buildLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(imageUrl: URL) {
        self.imageUrl = imageUrl
        imageView.kf.setImage(with: imageUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension PicViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        self.addSubview(imageView)
    }

    func setupConstraints() {

    }
}
