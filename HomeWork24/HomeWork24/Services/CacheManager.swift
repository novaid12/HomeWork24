//
//  CacheManager.swift
//  HomeWork24
//
//  Created by  NovA on 21.10.23.
//

import Alamofire
import AlamofireImage
import Foundation

final class CacheManager {
    private init() {}
    
    static let shared = CacheManager()
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
}
