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


extension UIImageView {
    /* Image downloader on UIImageView that will also use cached images when available */
    func downloadImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, width: CGFloat? = nil, downloadFinished: (()->())? = nil) {
        contentMode = mode
        let imageCache = AppDelegate.cache
        if let cachedImage = imageCache.getObject(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async() {
                self.image = cachedImage
                downloadFinished?()
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    var image = UIImage(data: data)
                else {
                     DispatchQueue.main.async() {
                        downloadFinished?()
                     }
                     return
                }
                if let newWidth = width, let newImage = self.resizeImage(image: image, newWidth: newWidth) {
                    image = newImage
                }
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async() {
                    self.image = image
                    downloadFinished?()
                }
            }.resume()
        }
    }
    
    /* Download Image Helper for url String */
    func downloadImage(link: String?, contentMode mode: UIViewContentMode = .scaleAspectFit, width: CGFloat? = nil, downloadFinished: (()->())? = nil) {
        guard let urlString = link, let url = URL(string: urlString) else { return }
        downloadImage(url: url, contentMode: mode, width: width, downloadFinished: downloadFinished)
    }
    
    /* Resize our downloaded image based on a given width (keep aspect ratio) */
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}

/* My go to hexstring extension */
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
