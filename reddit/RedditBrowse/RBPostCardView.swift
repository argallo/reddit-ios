//
//  RBPostCardView.swift
//  reddit
//
//  Created by Anthony Gallo on 3/20/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation
import UIKit

final class RBPostCardView: UIView {
    
    private let voteString = "Votes: "
    private let commentString = "Comments: "
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postVoteLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    
    struct ViewModel {
        let imageUrl: String?
        let title: String
        let voteCount: Int64?
        let commentCount: Int64?
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        waitingState(enabled: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/* Public access methods */
extension RBPostCardView {
    /* Applies the viewmodel onto our components */
    func apply(viewModel: ViewModel) {
        waitingState(enabled: false)
        postImageView.downloadImage(link: viewModel.imageUrl)
        postTitleLabel.text = viewModel.title
        postVoteLabel.text = voteString + String(viewModel.voteCount ?? 0)
        postCommentLabel.text = commentString + String(viewModel.commentCount ?? 0)
    }
}

/* Private methods */
extension RBPostCardView {
    /* We hide our views until they have data to show.
       We could implment some sort of loading indicator when in a waiting state */
    private func waitingState(enabled: Bool) {
        postImageView.isHidden = enabled
        postTitleLabel.isHidden = enabled
        postVoteLabel.isHidden = enabled
    }
}
