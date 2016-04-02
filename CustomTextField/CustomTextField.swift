//
//  CustomTextField.swift
//  CustomTextField
//
//  Created by HSIAOJOU WEN on 2016/4/2.
//  Copyright © 2016年 HSIAOJOU WEN. All rights reserved.
//

import UIKit

public enum CustomTextFieldMode {
    case LeftToRight, CenterStart, RightToLeft
}

public class CustomTextField: UITextField, UITextFieldDelegate {
    
    private var _Mode: CustomTextFieldMode = .LeftToRight
    var mode: CustomTextFieldMode {
        set {
            _Mode = newValue
        }
        get {
            return _Mode
        }
    }
    
    private var _lineWidth: CGFloat = 1.0
    var lineWidth: CGFloat {
        set {
            if newValue > CGRectGetHeight(self.frame) {
                _lineWidth = CGRectGetHeight(self.frame)
            }
            else if newValue < 0 {
                _lineWidth = 0
            }
            else {
                _lineWidth = newValue
            }
        }
        get {
            return _lineWidth
        }
    }
    
    private var _underLineColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    var underLineColor: UIColor {
        set {
            _underLineColor = newValue
        }
        get {
            return _underLineColor
        }
    }
    
    private var _lineColor = UIColor.redColor()
    var lineColor: UIColor {
        set {
            _lineColor = newValue
        }
        get {
            return _lineColor
        }
    }
    
    private var _duration: NSTimeInterval = 0.2
    var duration: NSTimeInterval {
        set {
            if newValue < 0 {
                _duration = 0
            }
            else {
                _duration = newValue
            }
        }
        get {
            return _duration
        }
    }
    
    override init(frame: CGRect) {
        // Setting delegate
        super.init(frame: frame)
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        // if it create from xib, you will setting delegate in here
        super.awakeFromNib()
        self.delegate = self
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        // underline with gray color
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, lineWidth)
        
        underLineColor.setStroke()
        
        let point1 = CGPointMake(0, rect.height-lineWidth) // start point
        let point2 = CGPointMake(rect.width, rect.height-lineWidth) // end point
        let point = [point1, point2]
        CGContextAddLines(context, point, 2)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.textFieldShouldBeginAnimation()
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        let array = self.layer.sublayers
        for layer in array! {
            if layer.isKindOfClass(CAShapeLayer) {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    // Animation
    func textFieldShouldBeginAnimation() {
        if mode == .RightToLeft {
            let path = bezierRTLLinePath()
            let bezier = CAShapeLayer()
            bezier.path = path.CGPath
            bezier.strokeColor = lineColor.CGColor
            bezier.lineWidth = lineWidth
            bezier.strokeStart = 0.0
            bezier.strokeEnd = 1.0
            self.layer .addSublayer(bezier)
            
            let anima = CABasicAnimation(keyPath: "strokeEnd")
            anima.duration = duration
            anima.fromValue = 0.0
            anima.toValue = 1.0
            bezier.addAnimation(anima, forKey: "LineAnimation")
        }
        else if mode == .CenterStart {
            // Left
            let leftPath = bezierCTLLinePath()
            let leftBezier = CAShapeLayer()
            leftBezier.path = leftPath.CGPath
            leftBezier.strokeColor = lineColor.CGColor
            leftBezier.lineWidth = lineWidth
            leftBezier.strokeStart = 0.0
            leftBezier.strokeEnd = 1.0
            self.layer .addSublayer(leftBezier)
            // Right
            let rightPath = bezierCTRLinePath()
            let rightBezier = CAShapeLayer()
            rightBezier.path = rightPath.CGPath
            rightBezier.strokeColor = lineColor.CGColor
            rightBezier.lineWidth = lineWidth
            rightBezier.strokeStart = 0.0
            rightBezier.strokeEnd = 1.0
            self.layer .addSublayer(rightBezier)
            
            let anima = CABasicAnimation(keyPath: "strokeEnd")
            anima.duration = duration
            anima.fromValue = 0.0
            anima.toValue = 1.0
            leftBezier.addAnimation(anima, forKey: "LineAnimation")
            rightBezier.addAnimation(anima, forKey: "LineAnimation")
        }
        else { // LTR
            let path = bezierLTRLinePath()
            let bezier = CAShapeLayer()
            bezier.path = path.CGPath
            bezier.strokeColor = lineColor.CGColor
            bezier.lineWidth = lineWidth
            bezier.strokeStart = 0.0
            bezier.strokeEnd = 1.0
            self.layer .addSublayer(bezier)
            
            let anima = CABasicAnimation(keyPath: "strokeEnd")
            anima.duration = duration
            anima.fromValue = 0.0
            anima.toValue = 1.0
            bezier.addAnimation(anima, forKey: "LineAnimation")
        }
    }
    
    // Mode: LTR
    func bezierLTRLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, CGRectGetHeight(self.frame)-lineWidth))
        path.addLineToPoint(CGPointMake(CGRectGetMaxX(self.frame), CGRectGetHeight(self.frame)-lineWidth))
        return path
    }
    // Mode: CTB
    func bezierCTLLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-lineWidth))
        path.addLineToPoint(CGPointMake(0, CGRectGetHeight(self.frame)-lineWidth))
        return path
    }
    func bezierCTRLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-lineWidth))
        path.addLineToPoint(CGPointMake(CGRectGetMaxX(self.frame), CGRectGetHeight(self.frame)-lineWidth))
        return path
    }
    // Mode: RTL
    func bezierRTLLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetMaxX(self.frame), CGRectGetHeight(self.frame)-lineWidth))
        path.addLineToPoint(CGPointMake(0, CGRectGetHeight(self.frame)-lineWidth))
        return path
    }
}
