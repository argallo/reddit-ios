//
//  Utils.swift
//  reddit
//
//  Created by Anthony Gallo on 3/19/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation
import UIKit

/* Allows us to safely check if an index will be out of bounds */
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/* Standard way for UIView to load iteself with a subview xib */
extension UIView {
    var className: String {
        return String(describing: type(of: self))
    }
    
    @discardableResult
    open func loadFromNib(name: String? = nil, bundle: Bundle? = nil) -> UIView? {
        let bundle = bundle ?? Bundle(for: classForCoder)
        let className = name ?? self.className
        guard let rootView = bundle.loadNibNamed(className, owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView)
        return rootView
    }
}

/* Image downloader on UIImageView that will also use cached images when available */
extension UIImageView {
    func downloadImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        let imageCache = AppDelegate.cache
        if let cachedImage = imageCache.getObject(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async() {
                    self.image = image
                }
            }.resume()
        }
    }
    
    func downloadImage(link: String?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let urlString = link, let url = URL(string: urlString) else { return }
        downloadImage(url: url, contentMode: mode)
    }
}
