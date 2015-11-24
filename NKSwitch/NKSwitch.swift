//
//  NKSwitch.swift
//  NKSwitchDemo
//
//  Created by Peng on 11/18/15.
//  Copyright © 2015 Peng. All rights reserved.
//

import UIKit

typealias ValueChangeHook = (value: Bool) -> Void

class NKSwitch: UIView {

    // MARK: - Property
    var backgroundLayer = CAShapeLayer()

    var valueChange : ValueChangeHook?
    var on : Bool = false
    var animateDuration : Double = 0.5

    // MARK: - Getter
    var isOn : Bool{
        return on
    }

    var switchColor : UIColor = UIColor(white: 0.95, alpha: 1)
    var onColor : UIColor = UIColor(red: 0.698, green: 1, blue: 0.353, alpha: 1)
    var offColor : UIColor = UIColor(red: 0.812, green: 0.847, blue: 0.863, alpha: 1)

    var circleLayer: CAShapeLayer = CAShapeLayer()
    var markLayer: CAShapeLayer = CAShapeLayer()

    var circleRadius: CGFloat {

        get {
            return self.bounds.height * 0.4
        }

    }

    let onMarkLayerPath: UIBezierPath = UIBezierPath()
    let offMarkLayerPath: UIBezierPath = UIBezierPath()
    let mediumMarkLayerPath: UIBezierPath = UIBezierPath()

    var rectForOffCirle: CGRect {

        get {
            return CGRectMake(bounds.origin.x - circleRadius, bounds.origin.y + (bounds.height/2.0 - circleRadius), 2.0*circleRadius, 2.0*circleRadius)
        }

    }

    var rectForOnCirle: CGRect {

        get {

            return CGRectMake(bounds.width - circleRadius, bounds.origin.y + (bounds.height/2.0 - circleRadius), 2.0*circleRadius, 2.0*circleRadius)

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayers()
    }

    func setUpLayers(){
        let tap = UITapGestureRecognizer(target: self, action: "changeValue")
        self.addGestureRecognizer(tap)

        let backLayerPath = UIBezierPath()

        backLayerPath.moveToPoint(CGPointMake(0, self.bounds.height/2.0))
        backLayerPath.addLineToPoint(CGPointMake(self.bounds.width, self.bounds.height/2.0))

        backgroundLayer.fillColor = switchColor.CGColor
        backgroundLayer.strokeColor = switchColor.CGColor
        backgroundLayer.lineWidth = self.bounds.height
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.path = backLayerPath.CGPath
        self.layer.addSublayer(backgroundLayer)

        let circleLayerRect: CGRect = isOn ? rectForOnCirle : rectForOffCirle
        let circleLayerPath: UIBezierPath = UIBezierPath(ovalInRect: circleLayerRect)

        circleLayer.fillColor = isOn ? onColor.CGColor : offColor.CGColor
        circleLayer.strokeColor = isOn ? onColor.CGColor : offColor.CGColor
        circleLayer.path = circleLayerPath.CGPath
        circleLayer.bounds = CGPathGetPathBoundingBox(circleLayerPath.CGPath)
        circleLayer.position = CGPointMake(CGRectGetMidX(circleLayerRect), CGRectGetMidY(circleLayerRect))
        self.layer.addSublayer(circleLayer)

        onMarkLayerPath.moveToPoint(CGPointMake(circleLayerRect.width*0.8, circleLayerRect.height*0.4))
        onMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.4, circleLayerRect.height*0.8))
        onMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.2, circleLayerRect.height*0.6))

        mediumMarkLayerPath.moveToPoint(CGPointMake(circleLayerRect.width*0.15, circleLayerRect.height*0.45))
        mediumMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.55, circleLayerRect.height*0.55))
        mediumMarkLayerPath.moveToPoint(CGPointMake(circleLayerRect.width*0.75, circleLayerRect.height*0.35))
        mediumMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.35, circleLayerRect.height*0.75))

        offMarkLayerPath.moveToPoint(CGPointMake(circleLayerRect.width*0.3, circleLayerRect.height*0.3))
        offMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.7, circleLayerRect.height*0.7))
        offMarkLayerPath.moveToPoint(CGPointMake(circleLayerRect.width*0.7, circleLayerRect.height*0.3))
        offMarkLayerPath.addLineToPoint(CGPointMake(circleLayerRect.width*0.3, circleLayerRect.height*0.7))

        markLayer.path = isOn ? onMarkLayerPath.CGPath : offMarkLayerPath.CGPath
        markLayer.fillColor = nil
        markLayer.strokeColor = UIColor.whiteColor().CGColor
        markLayer.lineWidth = 2.0
        markLayer.lineCap = kCALineCapRound
        markLayer.frame = circleLayerRect
        self.layer.addSublayer(markLayer)

    }

    func changeValue(){
        if valueChange != nil{
            valueChange!(value: isOn)
        }
        on = !on

        changeValueAnimate(isOn,duration: animateDuration)

    }

    // MARK: - Animate
    func changeValueAnimate(turnOn: Bool, duration: Double){


        let rotationTransformAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationTransformAnimation.fromValue = (isOn ? -1 : 1) * 2.0 * M_PI
        rotationTransformAnimation.toValue = (isOn ? 1 : -1) * 2.0 * M_PI

        let cirleMoveAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        cirleMoveAnimation.fromValue = isOn ? NSValue(CGPoint: CGPointMake(bounds.origin.x, bounds.height/2.0)): NSValue(CGPoint: CGPointMake(bounds.width, bounds.height/2.0))

        cirleMoveAnimation.toValue = isOn ? NSValue(CGPoint: CGPointMake(bounds.width, bounds.height/2.0)): NSValue(CGPoint: CGPointMake( bounds.origin.x, bounds.height/2.0))

        let cirleFillColorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
        cirleFillColorAnimation.fromValue = (isOn ? offColor.CGColor : onColor.CGColor) as AnyObject
        cirleFillColorAnimation.toValue = (isOn ? onColor.CGColor : offColor.CGColor) as AnyObject

        let cirleStrokeColorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
        cirleStrokeColorAnimation.fromValue = (isOn ? offColor.CGColor : onColor.CGColor) as AnyObject
        cirleStrokeColorAnimation.toValue = (isOn ? onColor.CGColor : offColor.CGColor) as AnyObject

        let cirleAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        cirleAnimationGroup.animations = [rotationTransformAnimation,cirleMoveAnimation, cirleFillColorAnimation, cirleStrokeColorAnimation]
        cirleAnimationGroup.duration = duration
        cirleAnimationGroup.removedOnCompletion = false
        cirleAnimationGroup.fillMode = kCAFillModeForwards
        self.circleLayer.addAnimation(cirleAnimationGroup, forKey: "cirleAnimationGroup")

        let markLayerRotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        markLayerRotationAnimation.fromValue = (isOn ? -1 : 1) * 2.0 * M_PI
        markLayerRotationAnimation.toValue = (isOn ? 1 : -1) * 2.0 * M_PI

        let markLayerPathAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        markLayerPathAnimation.values = [self.isOn ? self.offMarkLayerPath.CGPath : self.onMarkLayerPath.CGPath, self.mediumMarkLayerPath.CGPath, self.isOn ? self.onMarkLayerPath.CGPath : self.offMarkLayerPath.CGPath]
        markLayerPathAnimation.keyTimes = [0.0, 0.5, 1.0]

        let markLayerMoveAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position.x")
        markLayerMoveAnimation.fromValue = isOn ? bounds.origin.x : bounds.width
        markLayerMoveAnimation.toValue = isOn ? bounds.width : bounds.origin.x

        let markLayerAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        markLayerAnimationGroup.animations = [ markLayerRotationAnimation, markLayerPathAnimation, markLayerMoveAnimation]
        markLayerAnimationGroup.duration = duration
        markLayerAnimationGroup.removedOnCompletion = false
        markLayerAnimationGroup.fillMode = kCAFillModeForwards
        markLayerAnimationGroup.delegate = self
        self.markLayer.addAnimation(markLayerAnimationGroup, forKey: "markAnimationGroup")
        
    }
    
    
}