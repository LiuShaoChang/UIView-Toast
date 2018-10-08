//
//  BaseDefines.swift
//  ProjectWraper
//
//  Created by 刘少昌 on 2018/9/28.
//  Copyright © 2018 YJYX. All rights reserved.
//

import Foundation
import UIKit

// MARK:- 屏幕尺寸
let kScreenSize = UIScreen.main.bounds.size
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

// MARK:- 导航栏,状态栏,tab栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
func kNaviBarMaxY() -> CGFloat {
    return 0;
}

// MARK:- 路径
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
let kCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
let kTempPath = NSTemporaryDirectory()

// MARK:- 颜色
func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}

func RGB(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {
    return RGBA(r, g, b, 1.0)
}




