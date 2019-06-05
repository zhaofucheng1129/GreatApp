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
    var vertexBuffer: MTLBuffer!
    var texture: MTLTexture!
    
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
        //几何图形数据
        setupBuffer()
        //纹理数据
        setupTexture()
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
    
    func setupBuffer() {
        let vertices = [YLZVertex(position: [-0.5, -0.5], textureCoordinate: [0, 1]),
                        YLZVertex(position: [-0.5,  0.5], textureCoordinate: [0, 0]),
                        YLZVertex(position: [ 0.5, -0.5], textureCoordinate: [1, 1]),
                        YLZVertex(position: [ 0.5,  0.5], textureCoordinate: [1, 0])]
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<YLZVertex>.size * vertices.count, options: .cpuCacheModeWriteCombined)
    }
    
    func setupTexture() {
        let image = UIImage(named: "RqkEwMQmUo2uJ6RIsX6FYo0zehTVJZF=WB0WdjZiREHfC1534152392637.gif")
        texture = newTexture(with: image)
    }
    
    private func newTexture(with image: UIImage?) -> MTLTexture? {
        guard let imageRef = image?.cgImage else { return nil }
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let bitmapContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        bitmapContext?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        let texture: MTLTexture? = device.makeTexture(descriptor: textureDescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
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

        //几何图形顶点数据
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        //纹理数据
        commandEncoder.setFragmentTexture(texture, index: 0)
//        if #available(iOS 8.3, *) {
//            commandEncoder.setVertexBytes(vertices, length: MemoryLayout<YLZVertex>.size * 3, index: Int(YLZVertexInputIndexVertices.rawValue))
//        } else {
//
//        }
        
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
