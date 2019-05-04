//
//  MetalVeryBaseExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/5/5.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit

class MetalVeryBaseExample: UIViewController {

    override func loadView() {
        self.view = TOMetalView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class TOMetalView: UIView {
    
    var device: MTLDevice!
    var commonQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commnInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commnInit()
    }
    
    func commnInit() {
        device = MTLCreateSystemDefaultDevice()
        commonQueue = device?.makeCommandQueue()
        
        setupPipeline()
    }
    
    func setupPipeline() {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        
        let renderPassDescripor = MTLRenderPassDescriptor()
        renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1)
        renderPassDescripor.colorAttachments[0].texture = drawable.texture
        renderPassDescripor.colorAttachments[0].loadAction = .clear
        renderPassDescripor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commonQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescripor)!
        
        commandEncoder.setRenderPipelineState(pipelineState)
        let vertices = [YLZVertex(position: [ 0.5, -0.5], color: [1, 0, 0, 1]),
                        YLZVertex(position: [-0.5, -0.5], color: [0, 1, 0, 1]),
                        YLZVertex(position: [ 0.0,  0.5], color: [0, 0, 1, 1])]
        if #available(iOS 8.3, *) {
            commandEncoder.setVertexBytes(vertices, length: MemoryLayout<YLZVertex>.size * 3, index: Int(YLZVertexInputIndexVertices.rawValue))
        } else {
            
        }
        
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
