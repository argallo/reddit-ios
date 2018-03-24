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
    var keyListIndex = 0 //keeping track of next index to remove changes key removal from O(N) to O(1)
    
    init(cacheLimit: Int = 200) {
        maxCachedObjects = cacheLimit
        keyList = [K]()
        super.init()
        keyList.reserveCapacity(maxCachedObjects)
    }
    
    func setObject(_ obj: V, forKey key: K) {
        if keyList.count == maxCachedObjects {
            removeObject(forKey: keyList[keyListIndex])
            keyList[keyListIndex] = key
            keyListIndex = keyListIndex + 1 == keyList.count ? 0 : keyListIndex + 1
        } else {
            keyList.append(key)
        }
        super.setObject(obj, forKey: key)
    }
    
    func getObject(forKey key: AnyObject) -> V? {
        return super.object(forKey: key) as? V
    }
}
