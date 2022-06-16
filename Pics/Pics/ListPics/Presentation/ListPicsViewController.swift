//
//  ListPicsViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

class ListPicsViewController: UIViewController {
    var viewModel: ListPicsViewModelProtocol?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.register(PicViewCell.self, forCellWithReuseIdentifier: PicViewCell.identifer)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension ListPicsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }

    func setupConstraints() {

    }

    func configureViews() {
        viewModel?.pics.bindAndFire { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension ListPicsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.pics.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicViewCell.identifer, for: indexPath) as? PicViewCell, let pic = viewModel?.pics.value[indexPath.item] else {
            preconditionFailure("Failed to load collection view cell")
        }

        // TODO remove force unwrap
        cell.setup(imageUrl: URL(string: pic.downloadUrl)!)

        return cell
    }
}
