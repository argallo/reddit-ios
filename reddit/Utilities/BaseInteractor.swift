//
//  BaseInteractor.swift
//  reddit
//
//  Created by Anthony Gallo on 3/20/18.
//  Copyright © 2018 Anthony Gallo. All rights reserved.
//

import Foundation

class BaseInteractor {
    let webService: WebService
    
    //Dependency injection FTW
    init(webService: WebService) {
        self.webService = webService
    }
}
