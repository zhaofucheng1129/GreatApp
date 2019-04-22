//
//  WebImageManager.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/4/22.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit

public typealias DownloadProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)

public class WebImageManager {
    public static let shared = WebImageManager()
    
    public var defaultOptions = WebImageOptionsInfo.empty
    
    public var downloader: WebImageDownloader
    
    private let processingQueue: DispatchQueue
    
    private convenience init() {
        self.init(downloader: .default)
    }
    
    init(downloader: WebImageDownloader) {
        self.downloader = downloader
        processingQueue = DispatchQueue(label: "com.zhaofucheng.GreatApp.WebImageManager.processQueue.\(String.UUID())")
    }
    
    func retrieveImage(with url: URL, options: WebImageParsedOptionsInfo,
                       progressBlock: DownloadProgressBlock? = nil,
                       completionHandler: ((Result<Image, WebImageError>) -> Void)?) -> DownloadTask? {
        if options.forceRefresh {
            return loadAndCacheImage(with: url, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        } else {
            return loadAndCacheImage(with: url, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        }
    }
    
    func loadAndCacheImage(with url: URL, options: WebImageParsedOptionsInfo,
                           progressBlock: DownloadProgressBlock? = nil,
                           completionHandler: ((Result<Image, WebImageError>) -> Void)?) -> DownloadTask? {
        
        func cacheImage(_ result: Result<Image, WebImageError>) {
            completionHandler?(result)
        }
        
        return downloader.downloadImage(with: url, options: options, progressBlock: progressBlock, completionHandler: cacheImage)
    }
    
}

