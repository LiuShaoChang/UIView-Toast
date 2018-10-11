//
//  SCToast.swift
//  ProjectWraper
//
//  Created by 刘少昌 on 2018/9/29.
//  Copyright © 2018 YJYX. All rights reserved.
//

import UIKit

fileprivate struct ToastAssociateKeys {
    static var timer = "toast.timer"
    static var completion = "toast.completion"
}

public enum ToastImageRelativePosition {
    case leftRight
    case upDown
}

public enum ToastPosition {
    case top
    case center
    case bottom
    fileprivate func centerPoint(forToast toast:UIView, inSuperview superView:UIView, _ config:ToastConfig) -> CGPoint {
        
        let topPadding = config.toastVerticalMargin + superView.safeEdgeInsets.top
        let bottomPadding = config.toastVerticalMargin + superView.safeEdgeInsets.bottom

        switch self {
        case .top:
            return CGPoint.init(x: superView.bounds.size.width / 2.0, y: toast.frame.size.height / 2.0 + topPadding)
        case .center:
            return CGPoint.init(x: superView.bounds.size.width / 2.0, y: superView.bounds.size.height / 2.0)
        case .bottom:
            return CGPoint.init(x: superView.bounds.size.width / 2.0, y: superView.bounds.size.height - toast.frame.size.height / 2.0 - bottomPadding)
            
        }
    }
}

public struct ToastConfig {
    // duration
    var toastDefaultDuration: TimeInterval = 2.0
    var toastFadeAnimationDuration: TimeInterval = 0.2
    
    // position
    var toastHorizontalMargin: CGFloat = 10.0
    var toastVerticalMargin: CGFloat = 10.0
    var toastPosition = ToastPosition.center
    var toastImageRelativePosition = ToastImageRelativePosition.upDown
    
    // size
    var toastActivitySize = CGSize.init(width: 100.0, height: 100.0)
    var toastImageSize = CGSize.init(width: 100.0, height: 100.0)
    
    // label setting
    var toastMaxWidthPercent: CGFloat = 0.8 {
        didSet {
            toastMaxWidthPercent = max(min(toastMaxWidthPercent, 1.0), 0.0)
        }
    }
    var toastMaxHeightPercent: CGFloat = 0.8 {
        didSet {
            toastMaxHeightPercent = max(min(toastMaxHeightPercent, 1.0), 0.0)
        }
    }
    
    // message
    var toastMessageFont: UIFont = .systemFont(ofSize: 12.0)
    var toastMessageNumberOfLines = 0
    var toastMessageColor: UIColor = .white
    var toastMessageAlignment: NSTextAlignment = .left
    
    // title
    var toastTitleFont: UIFont = .systemFont(ofSize: 14.0)
    var toastTitleNumberOfLines = 0
    var toastTitleColor: UIColor = .white
    var toastTitleAlignment: NSTextAlignment = .center
    
    // background
    var toastBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    var toastCornerRadius:CGFloat = 10.0
    
    // shadow
    var toastDisplayShadow: Bool = false
    var toastShadowRadius: CGFloat = 6.0
    var toastShadowOffset: CGSize = CGSize(width: 4.0, height: 4.0)
    var toastShadowOpacity: Float = 0.8 {
        didSet {
            toastShadowOpacity = max(min(toastShadowOpacity, 1.0), 0.0)
        }
    }
    
    init() {}
    
}


// MARK: - extension
public extension UIView {
    var safeEdgeInsets:UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        }else {
            return .zero
        }
    }
    
    // MARK: - make toast
    
    func makeToast(_ msg:String) {
        guard let toast = toastView(msg, nil, nil) else { return }
        showToast(toast)
    }
    
    func makeToast(_ msg: String, _ title: String) {
        guard let toast = toastView(msg, title, nil) else { return }
        showToast(toast)
    }
    
    func makeToast(_ image: UIImage) {
        guard let toast = toastView(nil, nil, image) else { return }
        showToast(toast)
    }
    
    
    func makeToast(_ image: UIImage?, _ title: String?, _ message: String?, imageRelativePosition: ToastImageRelativePosition, position: ToastPosition, duration: TimeInterval) {
        
        var config = ToastConfig()
        config.toastImageRelativePosition = imageRelativePosition
        config.toastPosition = position
        config.toastDefaultDuration = duration
        makeToast(image, title, message, config)
        
    }
    
    func makeToast(_ image: UIImage?, _ title: String?, _ message: String?,_ configuration:ToastConfig, completion:(() -> Void)? = nil) {
        guard let toast = toastView(message, title, image, configuration) else { return }
        showToast(toast, position: configuration.toastPosition, config: configuration, completion: completion)
    }
    
    // MARK: - show toast
    fileprivate func showToast(_ toast: UIView, position:ToastPosition = ToastConfig().toastPosition, config:ToastConfig = ToastConfig(), completion:(() -> Void)? = nil) {
        
        let point = position.centerPoint(forToast: toast, inSuperview: self, config)
        showToast(toast, point: point, config: config, completion: completion)
    }
    
    fileprivate func showToast(_ toast: UIView, point: CGPoint, config:ToastConfig = ToastConfig(), completion:(() -> Void)? = nil) {
        
        toast.center = point
        toast.alpha = 0.0
        
        self.addSubview(toast)
        UIView.animate(withDuration: config.toastFadeAnimationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            toast.alpha = 1.0
        }) { _ in
            let timer = Timer(timeInterval: config.toastDefaultDuration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
            objc_setAssociatedObject(toast, &ToastAssociateKeys.timer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - show toastActivity
    
    
    // MARK: - hide toast
    @objc fileprivate func toastTimerDidFinish(_ timer: Timer) {
        guard let toast = timer.userInfo as? UIView else { return }
        hideToast(toast)
    }
    
    fileprivate func hideToast(_ toast: UIView) {
        if let timer = objc_getAssociatedObject(toast, &ToastAssociateKeys.timer) as? Timer {
            timer.invalidate()
        }
        UIView.animate(withDuration: ToastConfig().toastFadeAnimationDuration, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0.0
        }) { _ in
            toast.removeFromSuperview()
            if let completion = objc_getAssociatedObject(toast, &ToastAssociateKeys.completion) as? (() -> Void) {
                completion()
            }
        }
    }
    
    // MARK: - toastView
    fileprivate func toastView(_ msg:String?, _ title:String?, _ image:UIImage?, _ configuration:ToastConfig = ToastConfig()) -> UIView? {
        if msg == nil && title == nil && image == nil {
            return nil
        }
        var imageView: UIImageView?
        var titleLabel: UILabel?
        var messageLabel: UILabel?
        var imageRect = CGRect.zero
        var titleRect = CGRect.zero
        var messageRect = CGRect.zero
        
        let wrapperView = toastWrapperView(configuration)
        
        if let image = image {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.sizeToFit()
            imageRect.size.width = imageView!.bounds.size.width
            imageRect.size.height = imageView!.bounds.size.height
            if imageRect.size.width > self.bounds.size.width * configuration.toastMaxWidthPercent || imageRect.size.height > self.bounds.size.height * configuration.toastMaxHeightPercent {
                imageRect.size.width = configuration.toastImageSize.width
                imageRect.size.height = configuration.toastImageSize.height
            }
            imageRect.origin.x = configuration.toastHorizontalMargin
            imageRect.origin.y = configuration.toastVerticalMargin
            
        }
        
        if let title = title {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = configuration.toastTitleNumberOfLines
            titleLabel!.font = configuration.toastTitleFont
            titleLabel!.textColor = configuration.toastTitleColor
            titleLabel!.textAlignment = configuration.toastTitleAlignment
            titleLabel!.backgroundColor = UIColor.clear
            titleLabel!.text = title
            switch configuration.toastImageRelativePosition {
            case .leftRight:
                let maxTitleSize = CGSize(width: self.bounds.size.width * configuration.toastMaxWidthPercent - imageRect.maxX - configuration.toastHorizontalMargin, height: self.bounds.size.height * configuration.toastMaxHeightPercent - 2 * configuration.toastVerticalMargin)
                let titleSize = titleLabel!.sizeThatFits(maxTitleSize)
                titleRect.origin.x = imageRect.maxX + configuration.toastHorizontalMargin
                titleRect.origin.y = configuration.toastVerticalMargin
                titleRect.size = titleSize

            case .upDown:
                let maxTitleSize = CGSize(width: self.bounds.size.width * configuration.toastMaxWidthPercent - 2 * configuration.toastHorizontalMargin, height: self.bounds.size.height * configuration.toastMaxHeightPercent - imageRect.maxY - configuration.toastVerticalMargin)
                let titleSize = titleLabel!.sizeThatFits(maxTitleSize)
                titleRect.origin.x = configuration.toastHorizontalMargin
                titleRect.origin.y = imageRect.maxY + configuration.toastVerticalMargin
                titleRect.size = titleSize
                
            }
        }
        
        if let msg = msg {
            messageLabel = UILabel()
            messageLabel!.numberOfLines = configuration.toastMessageNumberOfLines
            messageLabel!.font = configuration.toastMessageFont
            messageLabel!.textColor = configuration.toastMessageColor
            messageLabel!.textAlignment = configuration.toastMessageAlignment
            messageLabel!.backgroundColor = UIColor.clear
            messageLabel!.text = msg
            
            switch configuration.toastImageRelativePosition {
            case .leftRight:
                let maxMsgSize = CGSize(width: self.bounds.size.width * configuration.toastMaxWidthPercent - imageRect.maxX - configuration.toastHorizontalMargin, height: self.bounds.size.height * configuration.toastMaxHeightPercent - titleRect.maxY - 2 * configuration.toastVerticalMargin)
                let msgSize = messageLabel!.sizeThatFits(maxMsgSize)
                messageRect.origin.x = imageRect.maxX + configuration.toastHorizontalMargin
                messageRect.origin.y = titleRect.maxY + configuration.toastVerticalMargin
                messageRect.size = msgSize
                
            case .upDown:
                let maxMsgSize = CGSize(width: self.bounds.size.width * configuration.toastMaxWidthPercent - 2 * configuration.toastHorizontalMargin, height: self.bounds.size.height * configuration.toastMaxHeightPercent - titleRect.maxY - 2 * configuration.toastVerticalMargin)
                let msgSize = messageLabel!.sizeThatFits(maxMsgSize)
                messageRect.origin.x = configuration.toastHorizontalMargin
                messageRect.origin.y = titleRect.maxY + configuration.toastVerticalMargin
                messageRect.size = msgSize
                
            }
        }
        
        var wrapperWidth: CGFloat = 0.0
        var wrapperHeight: CGFloat = 0.0
        let longerLabelWidth = max(titleRect.size.width, messageRect.size.width)
        
        switch configuration.toastImageRelativePosition {
        case .leftRight:
            var totalTextHeight: CGFloat = 0.0
            wrapperWidth = longerLabelWidth + 2 * configuration.toastHorizontalMargin
            if image != nil {
                wrapperWidth = imageRect.size.width + longerLabelWidth + 3 * configuration.toastHorizontalMargin
            }
            if title != nil && msg != nil {
                totalTextHeight = titleRect.size.height + messageRect.size.height + configuration.toastVerticalMargin
            }else {
                totalTextHeight = max(titleRect.size.height, messageRect.size.height)
            }
            let higherHeight = max(imageRect.size.height, totalTextHeight)
            wrapperHeight = higherHeight + 2 * configuration.toastVerticalMargin
            imageRect.origin.y = (wrapperHeight - imageRect.size.height) / 2
            
        case .upDown:
    
            wrapperWidth = max(longerLabelWidth, imageRect.size.width) + 2 * configuration.toastHorizontalMargin
            var totalHeight: CGFloat = 0.0
            if image != nil {
                if title != nil && msg != nil {
                    totalHeight = imageRect.size.height + titleRect.size.height + messageRect.size.height + 2 * configuration.toastVerticalMargin
                }else if title == nil && msg == nil {
                    totalHeight = imageRect.size.height
                }else if title != nil {
                    totalHeight = imageRect.size.height + titleRect.size.height + configuration.toastVerticalMargin
                }else {
                    totalHeight = imageRect.size.height + messageRect.size.height + configuration.toastVerticalMargin
                }
            }else {
                if title != nil && msg != nil {
                    totalHeight = titleRect.size.height + messageRect.size.height + configuration.toastVerticalMargin
                }else if title != nil {
                    totalHeight = titleRect.size.height
                }else {
                    totalHeight = messageRect.size.height
                }
            }
            wrapperHeight = totalHeight + 2 * configuration.toastVerticalMargin
            imageRect.origin.x = (wrapperWidth - imageRect.size.width) / 2
        }
        let textWidth = max(longerLabelWidth, imageRect.size.width)
        titleRect.size = CGSize(width: textWidth, height: titleRect.size.height)
        messageRect.size = CGSize(width: textWidth, height: messageRect.size.height)
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        if let imageview = imageView {
            imageview.frame = imageRect
            wrapperView.addSubview(imageview)
        }
        
        if let titlelabel = titleLabel {
            titlelabel.frame = titleRect
            wrapperView.addSubview(titlelabel)
        }
        
        if let msglabel = messageLabel {
            msglabel.frame = messageRect
            wrapperView.addSubview(msglabel)
        }
        
        return wrapperView
    }
    
    // wrapperView
    fileprivate func toastWrapperView(_ configuration:ToastConfig) -> UIView {
        let wrapperView = UIView()
        wrapperView.backgroundColor = configuration.toastBackgroundColor
        wrapperView.layer.cornerRadius = configuration.toastCornerRadius
        if configuration.toastDisplayShadow {
            wrapperView.layer.shadowColor = configuration.toastBackgroundColor.cgColor
            wrapperView.layer.shadowOpacity = configuration.toastShadowOpacity
            wrapperView.layer.shadowOffset = configuration.toastShadowOffset
            wrapperView.layer.shadowRadius = configuration.toastShadowRadius
        }
        return wrapperView
    }
    
    
}

