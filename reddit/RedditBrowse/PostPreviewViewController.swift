//
//  PostPreviewViewController.swift
//  reddit
//
//  Created by Anthony Gallo on 3/22/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation
import UIKit

/* Peek View Controller */
class PostPreviewViewController: UIViewController {
    private let previewImageView: UIImageView!
    private let previewImage: String

    init(previewImage: String) {
        self.previewImage = previewImage
        self.previewImageView = UIImageView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

/* Private methods */
extension PostPreviewViewController {
    private func configureSubviews() {
        self.view.addSubview(previewImageView)
        setupConstraints()
        // Download a fullscale image if there is one and then resize our view to center the image
        previewImageView.downloadImage(link: previewImage, contentMode: .scaleAspectFit, width: self.view.frame.size.width) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.preferredContentSize = strongSelf.previewImageView.image?.size ?? CGSize.zero
        }
    }
    
    /* Setup our constraints to fill the VC */
    private func setupConstraints() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        previewImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        previewImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        previewImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    }
}
