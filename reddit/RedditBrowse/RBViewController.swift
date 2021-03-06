//
//  ViewController.swift
//  reddit
//
//  Created by Anthony Gallo on 3/17/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import UIKit

/*
 Our output back to our interactor.
 Protocol consists of delegate calls that will trigger
 updates to the ViewModel
 */
protocol RBViewControllerOutput: class {
        func postTapped(at index: Int)
        func loadNewPage(initialLoad: Bool)
}

/*
 Our ViewController conforms to the input protocol so we can
 connect our viewModel updates in our interactor.
 */
public protocol RBViewControllerInput: class {
    var viewModel: RBViewModel { get set }
}

/* Reddit Browse View Model */
public struct RBViewModel {
    var posts: [ListingChildData]
}

class RBViewController: UIViewController, RBViewControllerInput {

    private var collectionView: UICollectionView!
    private let collectionViewInsets = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    private let size = CGSize(width: UIScreen.main.bounds.width - 20,
                            height: UIScreen.main.bounds.width * 150 / 400)
    private let pageLoadOffset = 2
    private let navTitle = "Reddit /r/pics"
    
    enum Identifier {
        static let collectionViewCell = "collectionViewCell"
    }
    
    var output: RBViewControllerOutput?
    var viewModel: RBViewModel = RBViewModel(posts: []) {
        didSet {
            reloadCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        output?.loadNewPage(initialLoad: true)
        configureCollectionView()
        self.view.addSubview(collectionView)
        registerForPreviewing(with: self, sourceView: collectionView)
    }
}

/* Private methods */
extension RBViewController {
    private func configureNav() {
        self.navigationItem.title = navTitle
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
    }
    
    /* Sets up our CollectionView for scrolling through posts */
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = collectionViewInsets
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(RBCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.collectionViewCell)
        collectionView.backgroundColor = UIColor(hexString: "f6f7f8")
    }
    
    /* Reloads collection view with updated VM and does so on the main thread */
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            UIView.performWithoutAnimation {
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

/* Collection View DataSource */
extension RBViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.collectionViewCell, for: indexPath) as? RBCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.apply(with: viewModel.posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.posts.count - pageLoadOffset {
            output?.loadNewPage(initialLoad: false)
        }
    }
}

/* Collection View Delegate */
extension RBViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.postTapped(at: indexPath.row)
    }
}

/* Flow Layout Delegate */
extension RBViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size
    }
}

/* Peek and Pop 3D touch Previewing Delegate*/
extension RBViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView.indexPathForItem(at: location), let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath),
            let previewString = viewModel.posts[indexPath.row].url {
            previewingContext.sourceRect = cellAttributes.frame
            let previewVC = PostPreviewViewController(previewImage: previewString)
            previewVC.preferredContentSize = cellAttributes.frame.size
            return previewVC
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {}
}


