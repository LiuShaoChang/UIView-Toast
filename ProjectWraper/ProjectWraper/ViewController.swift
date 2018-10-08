//
//  ViewController.swift
//  ProjectWraper
//
//  Created by 刘少昌 on 2018/9/28.
//  Copyright © 2018 YJYX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.makeToast(UIImage(named: "fast"), "路飞通缉令", "路飞这SB,赏金已经达到15亿贝利", imageRelativePosition: .leftRight, position: .bottom, duration: 10)
        
        
    }


}

