//
//  RBInteractor.swift
//  reddit
//
//  Created by Anthony Gallo on 3/19/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation

class RBInteractor: BaseInteractor {
    private let baseURL = "https://www.reddit.com/r/all/.json?limit=25"
    weak var viewModelHolder: RBViewControllerInput!
    
    private enum EntityState {
        case loading
        case done
    }
    
    private struct Entity {
        var posts: [ListingChildData]
        var state: EntityState
    }
    
    private var entity: Entity
    override init(webService: WebService) {
        entity = Entity(posts: [], state: .done)
        super.init(webService: webService)
    }
}

/* Public access methods */
extension RBInteractor: RBViewControllerOutput {
    /* handle tapping on specific post */
    func postTapped(at index: Int) {
        print("post tapped at \(index)")
    }
    
    /* Loads new page of posts if we're not already loading one. */
    func loadNewPage(initialLoad: Bool) {
        if entity.state != EntityState.loading {
            entity.state = .loading
            let urlString = initialLoad ? baseURL : constructUrl()
            makeRequest(with: urlString)
        }
    }
}

/* Private methods */
extension RBInteractor {
    /* Makes request and updates viewmodel with new post data */
    private func makeRequest(with urlString: String) {
        webService.makeRequest(with: urlString, into: Listing.self) { [weak self] (listing) in
            guard let listing = listing as? Listing else { return }
            self?.entity.posts += listing.data.children.map{ $0.data }
            self?.updateViewModel()
        }
    }
    
    /* calls didset in our VC which will reload the collection view with our new data */
    private func updateViewModel() {
        viewModelHolder.viewModel = RBViewModel(posts: entity.posts)
        entity.state = .done
    }
    
    /* We want to build a url that gets posts after our most recent post recieved */
    private func constructUrl() -> String {
        return baseURL + "&after=" + entity.posts.last!.name
    }
}
