//
//  OpenGLRenderVideoExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/5/6.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit
import AVFoundation

class OpenGLRenderVideoExample: UIViewController {

    var repeatPlay: Bool = true
    var assetReader: AVAssetReader?
    var videoEncodingIsFinished: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAsset()
    }
    
    func loadAsset() {
        let videoUrl = Bundle.main.url(forResource: "boy", withExtension: "mp4")!
        let videoAsset = AVAsset(url: videoUrl)
        
        videoAsset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            DispatchQueue.global().async {
                var error: NSError?
                let tracksStatus = videoAsset.statusOfValue(forKey: "tracks", error: &error)
                guard tracksStatus == .loaded else { return }
                self.processAsset(asset: videoAsset)
            }
        }
    }
    
    func processAsset(asset: AVAsset) {
        guard let assetRender = setupAssetReader(asset: asset) else { return }
        
        let readerVideoTrackOutput = assetRender.outputs.filter { $0.mediaType == .video }.first
        
        guard readerVideoTrackOutput != nil else { return }
        
        guard assetRender.startReading() else { return }

        while assetRender.status == .reading && repeatPlay {
            readNextVideoFrame(readerVideoTrackOutput: readerVideoTrackOutput!)
        }
    }
    
    func setupAssetReader(asset: AVAsset) -> AVAssetReader? {
        do {
            assetReader = try AVAssetReader(asset: asset)
        } catch {
            
        }
        guard let assetReader = assetReader else { return nil }
        
        if let videoTrack = asset.tracks(withMediaType: .video).first {
            let readerVideoTrackOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA])
            readerVideoTrackOutput.alwaysCopiesSampleData = false
            assetReader.add(readerVideoTrackOutput)
        }
        return assetReader
    }
    
    @discardableResult
    func readNextVideoFrame(readerVideoTrackOutput:AVAssetReaderOutput) -> Bool {
        guard let assetReader = assetReader else { return false}
        guard assetReader.status == .reading && !videoEncodingIsFinished else { return false }
        if let sampleBuffer = readerVideoTrackOutput.copyNextSampleBuffer() {
            print(sampleBuffer)
            return true
        } else {
            return false
        }
    }
}
