//
//  LocalImageDisplayExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/4/22.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit

class LocalImageDisplayExample: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(scrollView)
        
        if #available(iOS 9.0, *) {
            if #available(iOS 11.0, *) {
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
                scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
            }
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        } else {
            let top = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            let left = NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
            view.addConstraints([top, left, bottom, right])
        }
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.size = CGSize(width: view.width, height: 60)
        label.textAlignment = .center
        label.numberOfLines = 0
        scrollView.addSubview(label)
        
        addImage(with: "banana_anim@2x.webp", text: "WebP 香蕉动画 带有Blend图层")
        addImage(with: "wall-e_anim@2x.webp", text: "WebP 动画 没有Blend图层")
        addImage(with: "93f8089dgy1fun2fhm3amg20av0604qs.gif", text: "Gif 动画")
        addImage(with: "elephant.png", text: "APNG 动画 采用ImageIO解码")
        addImage(with: "312380_001.jpg", text: "JPG 图片")
    }
    
    func addImage(with name: String, text: String) {
        let image = Image(named: name)
        let imageView = ImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.size = CGSize(width: view.width, height: view.width)
        imageView.centerX = view.centerX
        imageView.top = scrollView.subviews.last?.bottom ?? 0 + 30
        scrollView.addSubview(imageView)
        
        let imageLabel = UILabel()
        imageLabel.backgroundColor = UIColor.clear
        imageLabel.size = CGSize(width: view.width, height: 20)
        imageLabel.top = imageView.bottom + 10
        imageLabel.textAlignment = .center
        imageLabel.text = text
        scrollView.addSubview(imageLabel)
        
        scrollView.contentSize = CGSize(width: view.width, height: imageLabel.bottom + 20)
    }
}
