//
//  GameViewController.swift
//  running
//
//  Created by wuha o on 2018/12/17.
//  Copyright © 2018年 wuha o. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
            
            let sceneData = try! NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
    
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
             archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            
            
            return scene
            }
            else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate:Bool {
        return true
    }

    
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask  {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)))
            } else {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.all.rawValue)))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden:Bool {
        return true
    }

}

