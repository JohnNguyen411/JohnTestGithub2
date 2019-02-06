//
//  FilmstripView.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class FilmstripView: UIView {

    // MARK: Data
    
    private static let itemSize: CGFloat = 48.0

    var numberOfPhotos: Int {
        return self.photos.count
    }

    private var photos: [UIImage] = []

    // MARK: Layout

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()

    private let thumbnailsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 6
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout).usingAutoLayout()
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.thumbnailsView.dataSource = self
        self.thumbnailsView.register(FilmstripCell.self, forCellWithReuseIdentifier: "cell")
        self.thumbnailsView.reloadData()
        self.addSubviews()
    }
    
    deinit {
        self.photos = []
        self.thumbnailsView.dataSource = nil
        self.thumbnailsView.removeFromSuperview()
    }

    private func addSubviews() {

        Layout.fill(view: self, with: self.backgroundView)

        self.addSubview(self.thumbnailsView)
        self.thumbnailsView.pinToSuperviewTop(spacing: 6)
        self.thumbnailsView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        self.thumbnailsView.pinBottomToSuperviewBottom(spacing: -6)
        self.thumbnailsView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.size.height / 2
        self.thumbnailsView.layer.cornerRadius = self.thumbnailsView.bounds.size.height / 2
    }

    // MARK: Photo management

    func add(photo: UIImage) {
        if let photoToAdd = photo.resized(to: FilmstripView.itemSize * UIScreen.main.scale) {
            self.photos += [photoToAdd]
        } else {
            self.photos += [photo]
        }
        self.thumbnailsView.reloadData()
        self.thumbnailsView.layoutIfNeeded()
        let indexPath = IndexPath(row: self.photos.count - 1, section: 0)
        self.thumbnailsView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func reload() {
        self.thumbnailsView.reloadData()
        self.thumbnailsView.layoutIfNeeded()
        let indexPath = IndexPath(row: self.photos.count - 1, section: 0)
        self.thumbnailsView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
}

extension FilmstripView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let filmstripCell = cell as? FilmstripCell else { return cell }
        filmstripCell.imageView.image = self.photos[indexPath.row]
        return filmstripCell
    }
}

fileprivate class FilmstripCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        Layout.fill(view: self.contentView, with: self.imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
