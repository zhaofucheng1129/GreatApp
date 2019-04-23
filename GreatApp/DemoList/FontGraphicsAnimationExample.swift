//
//  FontGraphicsAnimationExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/4/23.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit

class FontGraphicsAnimationExample: UIViewController {

    var pathLayer: CAShapeLayer?
    var penLayer: CALayer?
    var animationLayer: CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        animationLayer = CALayer()
        if #available(iOS 11.0, *) {
            self.animationLayer.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        } else {
            self.animationLayer.frame = CGRect(x: 0, y: 64, width: view.width, height: view.height - 64 - 44)
        }
        view.layer.addSublayer(animationLayer)
        setupTextLayer()
        startAnimation()
    }
    
    func setupTextLayer() {
        let letters = CGMutablePath()
        let font = CTFontCreateWithName("Helvetica-Bold" as CFString, 45, nil)
        let attrs = [NSAttributedString.Key.font: font]
        let attrString = NSAttributedString(string: "Swift字形动画", attributes: attrs)
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runArray = CTLineGetGlyphRuns(line) as! [CTRun]
        runArray.forEach { run in
            let dict = (CTRunGetAttributes(run) as! [CFString: CTFont])
            let runFont = dict[kCTFontAttributeName]
            (0..<CTRunGetGlyphCount(run)).forEach({ i in
                let range = CFRangeMake(i, 1)
                var glyph: CGGlyph = CGGlyph()
                var position: CGPoint = CGPoint()
                CTRunGetGlyphs(run, range, &glyph)
                CTRunGetPositions(run, range, &position)
                if let runFont = runFont,let letter = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                    let transform = CGAffineTransform(translationX: position.x, y: position.y)
                    letters.addPath(letter, transform: transform)
                }
            })
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.append(UIBezierPath(cgPath: letters))
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = animationLayer.bounds
        pathLayer.bounds = path.cgPath.boundingBox
        pathLayer.isGeometryFlipped = true
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = #colorLiteral(red: 0.9411764706, green: 0.2823529412, blue: 0.2823529412, alpha: 1)
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3
        pathLayer.lineJoin = .bevel
        
        animationLayer.addSublayer(pathLayer)
        
        self.pathLayer = pathLayer
        
        let penImage = Image(named: "pen.png")
        let penLayer = CALayer()
        penLayer.contents = penImage?.cgImage
        penLayer.anchorPoint = CGPoint.zero
        penLayer.frame = CGRect(x: 0, y: 0, width: penImage?.size.width ?? 0, height: penImage?.size.height ?? 0)
        pathLayer.addSublayer(penLayer)
        
        self.penLayer = penLayer
    }
    
    func startAnimation() {
        pathLayer?.removeAllAnimations()
        penLayer?.removeAllAnimations()
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 10.0
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathLayer?.add(pathAnimation, forKey: "strokeEnd")
        
        let penAnimation = CAKeyframeAnimation(keyPath: "position")
        penAnimation.duration = 10.0
        penAnimation.path = pathLayer?.path
        penAnimation.calculationMode = .paced
        penAnimation.fillMode = .forwards
        penAnimation.isRemovedOnCompletion = false
        penAnimation.delegate = self
        penLayer?.add(penAnimation, forKey: "position")
    }
}

extension FontGraphicsAnimationExample: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        penLayer?.isHidden = flag
        penLayer?.removeAllAnimations()
    }
}
