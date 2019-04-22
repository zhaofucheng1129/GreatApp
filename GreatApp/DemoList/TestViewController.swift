//
//  ImageIOViewController.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/3/31.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit
import CoreImage
import CommonCrypto
import WebKit
import Photos

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
//        let im = Image(named: "Rubik'sCube_anim.webp")
//        let imageView = ImageView(image: im)
//        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: 100, height: 100))
//        imageView.contentMode = .scaleAspectFill
//        view.addSubview(imageView)
        
        
        let imageView2 = ImageView()
        imageView2.load.image(with: URL(string: "http://littlesvr.ca/apng/images/GenevaDrive.webp")!)
        imageView2.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100))
        imageView2.contentMode = .scaleAspectFill
        view.addSubview(imageView2)
        
        /// 测试Array性能
//        var startTime = CFAbsoluteTimeGetCurrent()
//        var arr = [Int]()
//        print(arr.withUnsafeBufferPointer{ String(describing: $0) })
//        (1...10000000).forEach {
//            arr.append($0)
//        }
//        var endTime = CFAbsoluteTimeGetCurrent()
//        print(arr.withUnsafeBufferPointer{ String(describing: $0) })
//        debugPrint("Swift数组执行时长：\((endTime - startTime)*1000) 毫秒")
//
//        startTime = CFAbsoluteTimeGetCurrent()
//        let marr = NSMutableArray()
//        print(Unmanaged.passUnretained(marr).toOpaque())
//        (1...10000000).forEach {
//            marr.add($0)
//        }
//        endTime = CFAbsoluteTimeGetCurrent()
//        print(Unmanaged.passUnretained(marr).toOpaque())
//        debugPrint("OC数组执行时长：\((endTime - startTime)*1000) 毫秒")
        
        //        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn) as [String]
        //        for filter in filterNames {
        //            print(filter)
        //        }
        
//        let path = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        let size = view.size
//        DispatchQueue.global().async {
//            let image = UIImage(named: "170242vyyvfzsjeglgrqyf.jpg")?.resize(to: size, contentMode: .scaleAspectFit)?.cropping(from: path.cgPath)
//            DispatchQueue.main.async {
//                let imageView = UIImageView(image: image)
//                imageView.center = self.view.center
//                self.view.addSubview(imageView)
//            }
//        }
        
//        let label = UILabel(text: "Image/IO是Apple提供的一套用于图片编码解码的系统库，对外是一层非常直观易用的C的接口。上层的UIKit，Core Image，还有Core Graphics中的CGImage处理，都是依赖Image/IO库的。因此，掌握Image/IO的基本编解码操作，对一些图像相关的数据处理是非常必要的。这篇教程就主要从简单的用法，说明Image/IO的用法，完整的文档，可以参考Apple Image/IO", font: UIFont.systemFont(ofSize: 16))
//        label.numberOfLines = 0
//        label.frame = CGRect(x: 0, y: 0, width: view.width - 10, height: label.labelHeight(fitWidth: view.width - 10))
//        label.center = view.center
//        view.addSubview(label)
        //        label.sizeToFit()
        
        
//        let textField = UITextField(frame: CGRect(x: 30, y: 100, width: 300, height: 30), borderStyle: .roundedRect)
//        textField.placeholder = "其输入"
//        textField.placeholderColor = UIColor.red
//        textField.placeholderFont = UIFont.systemFont(ofSize: 9)
//        textField.paddingLeft = 20
//        textField.center = view.center
//        view.addSubview(textField)
//
//        textField.text = "    345@mail.some_domain_name.com.uk 111   "
//        print(textField.hasValidEmail)
//        print(textField.isValidEmail)
     
//        let value1: String? = nil
//        let value2: String? = "Hello"
//
//        print("There's \(value1, optStyle: .stripped) and \(value2, optStyle: .stripped)")
//
//        print("\("345@mail.some_domain_name.com.uk".md2)")
//        print("\("345@mail.some_domain_name.com.uk".md4)")
//        print("\("345@mail.some_domain_name.com.uk".md5)")
//        print("\("345@mail.some_domain_name.com.uk".sha1)")
//        print("\("345@mail.some_domain_name.com.uk".sha224)")
//        print("\("345@mail.some_domain_name.com.uk".sha256)")
//        print("\("345@mail.some_domain_name.com.uk".sha384)")
//        print("\("345@mail.some_domain_name.com.uk".sha512)")
//
//        let str = "http://测试url.text?aaa=中欧&bb=👴🏻👮🏽&cc=美国".urlEncode
//        print("\(str, optStyle: .stripped)")
//        print("\(str?.urlDecode, optStyle: .stripped)")
//
//        print("\(#""&><"#.escapingHtml)")
//
//        print("\("345@mail.some_domain_name.com.uk".hmacMD5(key: "url"))")
//        print("\("345@mail.some_domain_name.com.uk".hmacSHA1(key: "url"))")
//        print("\("345@mail.some_domain_name.com.uk".hmacSHA224(key: "url"))")
//        print("\("345@mail.some_domain_name.com.uk".hmacSHA256(key: "url"))")
//        print("\("345@mail.some_domain_name.com.uk".hmacSHA384(key: "url"))")
//        print("\("345@mail.some_domain_name.com.uk".hmacSHA512(key: "url"))")
//
//        let key = "url"
//        let cKey = key.cString(using: .utf8)!
//        let sstr = "345@mail.some_domain_name.com.uk"
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
//        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA224), cKey, cKey.count, sstr, sstr.count, &digest)
//        let data = Data(bytes: digest)
//        print(data.map { String(format: "%02hhx", $0) }.joined())
//
//
//        print("345@mail.some_domain_name.com.uk".crc32)
//
//        print("   345@mail.some    domain_name.com.uk    ".trimmed)
//
//        var arr = [1,2,3,4,5,5,7,8,9,10]
////        print(arr.popFirst())
////        print(arr.popLast())
//        print(arr)
//        print(arr.append(contentsOf: [9,8,7]))
//
//        do {
//            let data = try PropertyListSerialization.data(fromPropertyList: arr, format: .xml, options: .init())
//            var array: Array<Int>? = Array.array(plistData: data)
//            array?.append(111)
//            print("\(array, default: "nil")")
//
//        } catch {
//
//        }
//
//        print(arr.jsonString!)
//        var jsonArray: Array<Int> = Array.array(jsonString: arr.jsonString!)!
//        print(jsonArray)
//        jsonArray.append(878787)
//        print(jsonArray)
//
//        print(UIDevice.systemVersion())
//        print(UIDevice.isSimulator())
//        print(UIDevice.machineModel())
//        print(UIDevice.machineModelName())
//
//        print("是否越狱：\(UIDevice.isJailbroken())")
//
//        print("总空间：\(UIDevice.diskSpace()), 可用空间：\(UIDevice.diskSpaceFree()), 已用空间：\(UIDevice.diskSpaceUsed())")
//
//        print(UIDevice.ipAddressInWifi())
//        print(UIDevice.ipAddressInCellular())
//        print(UIDevice.cpuCount())
        
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
//                print(UIDevice.cpuUsage())
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
//        print("这是啥")
//        print(ProcessInfo.processInfo.globallyUniqueString)
//        print(String.documentsDirectoryPath)
//        print(String.cachesDirectoryPath)
//        print(String.libraryDirectoryPath)
//        print(String.tmpDirectoryPath)
//
//        print("是否破解:\(UIApplication.isCracked)")
        
//        let btn = UIButton(type: .system)
//        btn.size = CGSize(width: 200, height: 30)
//        btn.center = view.center
//        view.addSubview(btn)
//
//        btn.setAction(events: .touchUpInside) { _ in
//            print("这又是一个按钮")
//        }
//
//        btn.addAction(events: .touchUpInside) { (btn) in
//            print("这又是一个按钮")
//        }
//
//        print("\(btn.value(forKeyPath: "tintColor"))")
//        print("\(btn.value(forKeyPath: #keyPath(UIButton.tintColor)))")
//        print("\(btn[keyPath:\UIButton.tintColor]))")
        
//        textField.addObserverAction(keyPath: #keyPath(UITextField.text)) { (textField, old, new) in
//            print(new)
//        }

//        String.UUID().enumerate(regex: "\\d", options: .caseInsensitive, closure: { (str, range, stop) in
//            print(str)
//        })
//
//        let uuid = String.UUID()
//        print(uuid)
//        print(uuid.replace(regex: "\\d", options: .caseInsensitive, with: "-"))
//        print("    \n   ".isNotBlank)

//        let date = Date()
//
//        print("\(date.year)年 \(date.month)月 \(date.day)日 星期\(date.weekdayOrdinal) \(date.hour):\(date.minute):\(date.second):\(date.nanosecond)")
//
//        print(date)
//        print(date.adding(days: 2).adding(weaks: 1).adding(hours: 2))
//
//        print(date.string(format: "yyyy-MM-dd HH:mm:ss"))
//
//        print(date.isoFormat)
//
//        let dictionaryData: [String : String] = ["5"  : "Five",
//                                                 "6"  : "Siv",
//                                                 "7"  : "Seven",
//                                                 "1"  : "One",
//                                                 "2"  : "Two",
//                                                 "3"  : "Three",
//                                                 "4"  : "Four",
//                                                 "8"  : "Eight"]
//        print(dictionaryData.allKeysSorted)
//        print(dictionaryData.allValuesSortedByKeys)
        
//        if #available(iOS 8.2, *) {
//            print("\(UIFont.systemFont(ofSize: 10).fontWeight)")
//        } else {
//            // Fallback on earlier versions
//        }
//        print(String.documentsDirectoryPath)
//
//        DispatchQueue.global().async {
//            print(UIScreen.main.scale)
//        }
//
//        let fontPathView = FontBezierPathView()
//        fontPathView.size = CGSize(width: view.width, height: 400)
//        fontPathView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
//        fontPathView.center = view.center
//        view.addSubview(fontPathView)
        
        
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
//                print("CPU使用量:\(UIApplication.cpuUsage())")
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        
//        let alert = UIAlertController.init(title: "提示", message: "这是一个提示", preferredStyle: .alert)
//        alert.addAction(title: "确定")
//        alert.addTextField(closure: { (field) in
//            print(field.text)
//        })
//        alert.show()
        
//        "a>b".unicodeScalars.forEach {
//            print($0)
//        }
        
//        let image = UIImage(named: "16r18.jpg")
//        let ti = image?.roundedCorner(radius: 150, corners: [.topLeft, .bottomRight],
//                                      size: CGSize(width: 300, height: 300),
//                                      mode: .scaleAspectFill, borderWidth: 5,
//                                      borderColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), borderLineJoin: .round)
//
//        let imageView = UIImageView(image: ti?.rotateRight90())
//        imageView.center = view.center
//        view.addSubview(imageView)
//        print(view.frame)
//        print(view.frame.applying(CGAffineTransform(rotationAngle: .pi / 6)))
        
        
//        let v = UIView()
//        v.frame = CGRect(x: 50, y: 50, width: 60, height: 200)
//        v.center = view.center
//        v.backgroundColor = UIColor(hexString: "880000")
//        view.addSubview(v)
//        print(v.frame.standardized)
        
//        print("v.origin = \(v.origin)")
//        print("p.origin = \(p.origin)")
//        print(v.convertPoint(point: v.origin, toViewOrWindow: p))
//        print(v.convert(v.origin, to: p))
        
        
        // result = (fromView.frame.origin - fromView.bounds.origin) + point - (toView.frame.origin - toView.bounds.origin)
        
        
//        //APNG
//        if let apngUrl = Bundle.main.url(forResource: "elephant", withExtension: "png"),
//            let source = CGImageSourceCreateWithURL(apngUrl as CFURL, nil){
//            let frameCount = CGImageSourceGetCount(source)
//            print("有\(frameCount)帧")
//
//            var images: [UIImage] = []
//            var totalDuration:Double = 0
//            var width:Double = 0
//            var height: Double = 0
//
//            DispatchQueue.global().async {
//                for index in 0..<frameCount {
//                    if let frameProperties:NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, index, nil),
//                        let pngProperties = frameProperties[kCGImagePropertyPNGDictionary] as? NSDictionary{
//
////                        let exifOrientation = frameProperties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation
//
//                        if let duration = pngProperties[kCGImagePropertyAPNGUnclampedDelayTime] as? Double,
//                            let imageRef = CGImageSourceCreateImageAtIndex(source, index, nil),
//                            let pixelWidth = frameProperties[kCGImagePropertyPixelWidth] as? Double,
//                            let pixelHeight = frameProperties[kCGImagePropertyPixelHeight] as? Double{
//                            let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
//                            images.append(image)
//                            print("当前帧持续时间\(duration)")
//                            totalDuration += duration
//                            width = pixelWidth
//                            height = pixelHeight
//                        }
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    let image = UIImage.animatedImage(with: images, duration: totalDuration)
//                    let imageView = UIImageView(image: image)
//                    imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//                    imageView.center = self.view.center
//                    self.view.addSubview(imageView)
//                }
//            }
//
//        }
        
        
        
//        if let imageUrl = Bundle.main.url(forResource: "16r19", withExtension: "jpg") {
//            do {
//                let data = try Data(contentsOf: imageUrl)
//
//                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
//                    return
//                }
//
//                if let properties: NSDictionary = CGImageSourceCopyProperties(source, nil) {
//                    print("FileSize = \(String(describing: properties[kCGImagePropertyFileSize]))")
//
//                    if let exifProperties = properties[kCGImagePropertyExifDictionary] as? NSDictionary {
//                        print("拍摄时间:\(String(describing: exifProperties[kCGImagePropertyExifDateTimeOriginal]))")
//                    }
//
//                    if let imageProperties: Dictionary = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as Dictionary? {
//                        let width = imageProperties[kCGImagePropertyPixelWidth] as? UInt
//                        let height = imageProperties[kCGImagePropertyPixelHeight] as? UInt
//                        let hasAlpha = imageProperties[kCGImagePropertyHasAlpha] as? Bool
//                        let orientation = imageProperties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation
//                        print("宽度：\(width), 高度：\(height), 是否有Alpha:\(hasAlpha), 方向：\(orientation)")
//                    }
//                }
//
//                DispatchQueue.global().async {
//                    guard let imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return }
//                    let imageOrientation = UIImage.Orientation.up
//                    let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: imageOrientation)
//
//                    DispatchQueue.main.async {
//                        let imageView = UIImageView(image: image)
//                        imageView.frame = self.view.bounds
//                        self.view.addSubview(imageView)
//                    }
//                }
//
//
//            } catch {
//
//            }
//        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
