//
//  ViewController.swift
//  C4Swift
//
//  Created by travis on 2014-10-28.
//  Copyright (c) 2014 C4. All rights reserved.
//

import UIKit
import C4UI
import C4Core
import C4Animation

class ViewController: C4CanvasController {
    let bg = C4Image("statusBarBG1px")
    let alertBar = AlertBar()
    let needle = C4Image("needle")
    let screen1 = C4Image("screen1")
    let rotationScale = -1.495*M_PI
    let brakeImageContainer = C4View()
    let brakeTemp01 = C4Image("brakeTemp01")
    let brakeTemp02 = C4Image("brakeTemp02")
    let brakeTempOverlay = C4Image("brakeTempOverlay")
    var popup = C4Rectangle(frame: C4Rect())
    var popupImage = C4Image("popup")
    var yesButton = C4Circle(center: C4Point(269,305), radius: 8)
    var noButton = C4Circle(center: C4Point(355,305), radius: 8)
    let lines = C4Image("lines")
    var linesMask = C4Rectangle(frame: C4Rect())
    let barsRed = C4Image("barsRed")
    var barsRedMask = C4Rectangle(frame: C4Rect())
    let barsGrey = C4Image("barsGrey")
    var barsGreyMask = C4Rectangle(frame: C4Rect())
    
    override func setup() {
        view.backgroundColor = UIColor(patternImage: bg.uiimage)
        var neutech = UIImage(named: "neutech")
        neutech = neutech?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: neutech, landscapeImagePhone: neutech, style: .Plain, target: self, action:NSSelectorFromString("reset"))
        
        var driveOnTitleLogo = UIImage(named: "driveOnTitleLogo")
        self.navigationItem.titleView = UIImageView(image: driveOnTitleLogo)
        
        var gears = UIImage(named: "gears")
        gears = gears?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: gears, landscapeImagePhone: gears, style: .Plain, target: nil, action: nil)

        self.navigationController?.view.add(alertBar.canvas)
        
        screen1.origin = C4Point(0,64)
        canvas.add(screen1)

        needle.anchorPoint = C4Point(0.88,0.12)
        needle.center = C4Point(477,236)
        canvas.add(needle)
        
        brakeTemp01.interactionEnabled = true
        
        brakeTemp01.addTapGestureRecognizer { (location, state) -> () in
            self.flip01()
        }
        
        brakeTemp02.addTapGestureRecognizer { (location, state) -> () in
            self.flip02()
        }
        
        brakeTempOverlay.addTapGestureRecognizer { (location, state) -> () in
            self.revealPopup()
        }
        
        brakeTemp02.interactionEnabled = true
        brakeTempOverlay.interactionEnabled = true
        brakeTemp02.add(brakeTempOverlay)
        
        brakeImageContainer.frame = brakeTemp01.bounds
        brakeImageContainer.origin = C4Point(461,572)
        brakeImageContainer.add(brakeTemp01)
        canvas.add(brakeImageContainer)
        
        popup.interactionEnabled = false
        popup.frame = screen1.bounds
        popupImage.center = popup.center
        popup.add(popupImage)
        popup.origin = screen1.origin
        popup.backgroundColor = C4Color(red: 0, green: 0, blue: 0, alpha: 0.4)
        popup.opacity = 0.0
        canvas.add(popup)
    
        popupImage.interactionEnabled = true
        yesButton.fillColor = clear
        yesButton.strokeColor = clear
        popupImage.add(yesButton)

        yesButton.addTapGestureRecognizer { (location, state) -> () in
            self.yesButton.fillColor = green
            self.noButton.fillColor = clear
        }

        noButton.fillColor = red
        noButton.strokeColor = clear
        popupImage.add(noButton)
        
        noButton.addTapGestureRecognizer { (location, state) -> () in
            self.yesButton.fillColor = clear
            self.noButton.fillColor = red
        }
        
        lines.origin = C4Point(82,470)
        linesMask = C4Rectangle(frame: lines.bounds)
        linesMask.origin = C4Point(-linesMask.width,0)
        lines.layer?.mask = linesMask.layer
        popupImage.add(lines)
        
        barsGrey.origin = C4Point(496,460)
        barsGreyMask = C4Rectangle(frame: barsRed.bounds)
        barsGreyMask.origin = C4Point(-barsGreyMask.width,0)
        barsGrey.layer?.mask = barsGreyMask.layer
        popupImage.add(barsGrey)
        
        barsRed.origin = barsGrey.origin
        barsRedMask = C4Rectangle(frame: barsRed.bounds)
        barsRedMask.fillColor = red
        barsRedMask.origin = C4Point(-barsRedMask.width,0)
        barsRed.add(barsRedMask)
        barsRed.layer?.mask = barsRedMask.layer
        popupImage.add(barsRed)
    }
    
    func reset() {
        
    }
    
    func flip01() {
        UIView.transitionFromView(brakeTemp01.view, toView: brakeTemp02.view, duration: 0.25, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
    }
    
    func flip02() {
        UIView.transitionFromView(brakeTemp02.view, toView: brakeTemp01.view, duration: 0.25, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
    }
    
    func revealPopup() {
        popup.interactionEnabled = true
        C4ViewAnimation(duration: 0.5) {
            self.popup.opacity = 1.0
        }.animate()
        delay(0.25) {
            C4ViewAnimation(duration: 0.25) {
                self.popupImage.opacity = 1.0
            }.animate()
       }
        delay(0.5) {
            C4ViewAnimation(duration: 0.66) {
                self.linesMask.origin = C4Point()
            }.animate()
        }
        delay(0.75) {
            C4ViewAnimation(duration: 0.66) {
                self.barsGreyMask.origin = C4Point()
            }.animate()
        }
        delay(1.0) {
            C4ViewAnimation(duration: 0.66) {
                self.barsRedMask.origin = C4Point()
            }.animate()
        }
    }
}