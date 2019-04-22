//
//  UrlImageDisplayExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/4/23.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit

class UrlImageCell: UITableViewCell {
    let urlImageView: ImageView
    let progressLayer: CAShapeLayer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        urlImageView = ImageView()
        progressLayer = CAShapeLayer()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(urlImageView)
        urlImageView.contentMode = .scaleAspectFill
        urlImageView.clipsToBounds = true
        
        
        urlImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            urlImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
            urlImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
            urlImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
            urlImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        } else {
            let width = NSLayoutConstraint(item: urlImageView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: urlImageView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0)
            let centerX = NSLayoutConstraint(item: urlImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: urlImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
            contentView.addConstraints([width, height, centerX, centerY])
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: progressLayer.height / 2))
        path.addLine(to: CGPoint(x: contentView.width, y: progressLayer.height / 2))
        progressLayer.lineWidth = 4
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor(red: 0, green: 0.640, blue: 1, alpha: 0.720).cgColor
        progressLayer.lineCap = .butt
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        urlImageView.layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressLayer.size = CGSize(width: contentView.width, height: 4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with url: URL) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.isHidden = true
        progressLayer.strokeEnd = 0
        CATransaction.commit()
        
        urlImageView.load.image(with: url, placeholder: nil, options: nil, progressBlock: { [weak self] (receivedSize, totalSize) in
            if let strongSelf = self {
                let progress = CGFloat(receivedSize) / CGFloat(totalSize)
                if strongSelf.progressLayer.isHidden {
                    strongSelf.progressLayer.isHidden = false
                    strongSelf.progressLayer.strokeEnd = progress
                }
            }
        }) { [weak self] result in
            if let strongSelf = self {
                strongSelf.progressLayer.isHidden = true
            }
        }
    }
}

class UrlImageDisplayExample: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(white: 0.217, alpha: 1)
        
        tableView.register(UrlImageCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = nil
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageLinks.count * 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.width * 3.0 / 4.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UrlImageCell
        cell.setImage(with: URL(string: imageLinks[indexPath.row % imageLinks.count])!)
        return cell
    }
    
    
    
    let imageLinks = [
        /*
         You can add your image url here.
         */
        
        "http://d.hiphotos.baidu.com/image/h%3D300/sign=e95179517d8da977512f802b8050f872/91529822720e0cf3740bf4990446f21fbf09aad0.jpg",
        
        "http://5b0988e595225.cdn.sohucs.com/images/20181011/f8150319317b4a9e93adbbc7d39a511b.gif",
        "http://img.zcool.cn/community/038f39e58e5ceefa801219c77372908.gif",
        "http://images01.mopimg.cn/imgs/20180105/20180105_b18f8be32578981c14817ba2cae536d9.GIF",
        "http://g.hiphotos.baidu.com/image/pic/item/960a304e251f95caef9fc8dbc2177f3e67095270.jpg",
        "http://hbimg.b0.upaiyun.com/d9a615eb35e32f6135c3abcfa754d1a8cac6d8d78e1b4-YuLQeL_fw658",
        "http://hbimg.b0.upaiyun.com/d46843eaca6be4e249b2a05687e5ed80019e5d31f000a-MFBejP_fw658",
        "http://s9.rr.itc.cn/r/wapChange/20171_11_17/a76q7a5718413873619.gif",
        "http://hbimg.b0.upaiyun.com/9360d6299ac35682cbf0ddb05ab51b2d83d13cf029586c-Tk25d5_fw658",
        "http://a.hiphotos.baidu.com/image/pic/item/42a98226cffc1e174ab08f4a4190f603738de9ba.jpg",
        "http://a.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2e69c73c6a44c2d562843568fe.jpg",
        "http://s9.rr.itc.cn/r/wapChange/20167_21_23/a9mlo09282513470362.jpg",
        "http://hbimg.b0.upaiyun.com/89d4be26a519457eadb8dc4379f9e70b1b6c90fbffa2f-2SeNdX_fw658",
        
        "http://s7.sinaimg.cn/mw690/002YXZYygy6TQIvMLZk06&690",
        "http://hbimg.b0.upaiyun.com/42c4924e4a110fe9e7f7c3121b8593f653f211781a0993-DMLnji_fw658",
        
        "http://img4.imgtn.bdimg.com/it/u=254618362,2906926008&fm=200&gp=0.jpg",
        "http://pic3.16pic.com/00/50/33/16pic_5033174_b.jpg",
        "http://cdn.duitang.com/uploads/item/201402/27/20140227194048_vHzJC.jpeg",
        "http://pic1.16pic.com/00/49/83/16pic_4983642_b.jpg",
        "http://i0.hdslb.com/bfs/article/c31701a0a1fc0220f95f2567b4812453277e7433.jpg",
        "http://pic1.16pic.com/00/07/65/16pic_765243_b.jpg",
        "http://b-ssl.duitang.com/uploads/item/201710/01/20171001105830_wWQej.jpeg",
        "http://i2.hdslb.com/bfs/archive/b8ac9e6173c533cca163418168f93bcc7f030a46.jpg",
        "http://i0.hdslb.com/bfs/archive/18aa596df3e73b48e454074974af4fb0f33fc7c4.jpg",
                 
        // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
        "http://littlesvr.ca/apng/images/SteamEngine.png",
        "http://littlesvr.ca/apng/images/BladeRunner.webp",
    ]

}
