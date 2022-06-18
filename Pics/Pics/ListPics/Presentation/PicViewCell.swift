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

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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

    func setup(imageUrl: URL?) {
        self.imageUrl = imageUrl
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl) { result in
            if case let .failure(error) = result,
               case let .imageSettingError(reason) = error,
               case .emptySource = reason {
                    self.imageView.kf.indicator?.startAnimatingView()
            }
        }
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
