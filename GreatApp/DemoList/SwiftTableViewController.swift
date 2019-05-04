//
//  ViewController.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/3/4.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit
import CoreImage

class SwiftTableViewController: UIViewController {
    
    fileprivate var titles: [String] = []
    fileprivate var className: [String] = []
    @IBOutlet weak var tableView: UITableView!
    static let cellId = "SwiftTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SwiftTableViewController.cellId)
        addCell("加载本地图片", className: "LocalImageDisplayExample")
        addCell("加载网络图片", className: "UrlImageDisplayExample")
        addCell("CoreText字形动画", className: "FontGraphicsAnimationExample")
        addCell("AudioUnit播放音乐", className: "AudioUnitPlayMusicExample")
        addCell("AudioUnit播放音乐AUGraph方式", className: "AudioUnitPlayMusicWithAUGraphExample")
        addCell("Metal中的HelloWorld", className: "MetalVeryBaseExample")
        addCell("测试界面", className: "TestViewController")
        tableView.reloadData()
    }

    private func addCell(_ title: String, className: String) {
        self.titles.append(title)
        self.className.append(className)
    }
    
}

extension SwiftTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwiftTableViewController.cellId, for: indexPath)
        cell.textLabel?.text = self.titles[indexPath.row]
        return cell
    }
}

extension SwiftTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let className = self.className[indexPath.row]
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let moduleName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String,
            let cls = NSClassFromString(moduleName + "." + className),
            let vcCls = cls as? UIViewController.Type else {
            return
        }
        
        self.navigationController?.pushViewController(vcCls.init(), animated: true)
        
    }
}

