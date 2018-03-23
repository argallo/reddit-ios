//
//  CachingService.swift
//  reddit
//
//  Created by Anthony Gallo on 3/22/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation

class CachingService<K: AnyObject, V: AnyObject>: NSCache<AnyObject, AnyObject> {
    let maxCachedObjects: Int //Todo: change this to bytes 
    var keyList: [K]
    
    init(cacheLimit: Int = 200) {
        maxCachedObjects = cacheLimit
        keyList = [K]()
        super.init()
        keyList.reserveCapacity(maxCachedObjects)
    }
    
    override func setObject(_ obj: AnyObject, forKey key: AnyObject) {
        if keyList.count == maxCachedObjects {
            self.removeObject(forKey: keyList.remove(at: 0))
        }
        keyList.append(key as! K)
        super.setObject(obj, forKey: key)
    }
    
    func getObject(forKey key: AnyObject) -> V? {
        return super.object(forKey: key) as? V
    }
}
