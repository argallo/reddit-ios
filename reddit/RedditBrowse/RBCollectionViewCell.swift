//
//  MyCollectionViewCell.swift
//  reddit
//
//  Created by Anthony Gallo on 3/19/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation
import UIKit

class RBCollectionViewCell: UICollectionViewCell {
    
    private var postCardView: RBPostCardView!
    
    override init(frame: CGRect) {
        postCardView = RBPostCardView(frame: frame)
        super.init(frame: frame)
        contentView.addSubview(postCardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        postCardView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        postCardView.postCommentLabel.text = ""
        postCardView.postVoteLabel.text = ""
        postCardView.postTitleLabel.text = ""
        postCardView.postImageView.image = nil
    }
}

/* Public access methods */
extension RBCollectionViewCell {
    /* Apply Post data to our subview: RBPostCardView */
    func apply(with post: ListingChildData){
        postCardView.apply(viewModel: RBPostCardView.ViewModel(imageUrl: post.thumbnail, title: post.title, voteCount: post.ups, commentCount: post.num_comments))
    }
}
