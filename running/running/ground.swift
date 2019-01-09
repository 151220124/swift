//
//  plantform.swift
//  running
//
//  Created by wuha o on 2018/12/19.
//  Copyright © 2018年 wuha o. All rights reserved.
//

import SpriteKit

class ground:SKNode{
    //地面宽度
    var width :CGFloat = 0.0
    //地面高度
    var height :CGFloat = 10.0
    
    
    var isinsameheight = false
    
    func onCreate(arrSprite:[SKSpriteNode]){
        
        for ground in arrSprite {
            
            ground.position.x = self.width
            
            self.addChild(ground)
            
            self.width += ground.size.width
        }
        //判断是否有地面高度差
        if arrSprite.count<=3 {
            isinsameheight = true
        }
        
        self.zPosition = 20

        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.width,height: self.height),
                                         center: CGPoint(x:self.width/2, y:0))
        //设置物理标识
        self.physicsBody?.categoryBitMask = kick.platform
        //不响应响应物理效果
        self.physicsBody?.isDynamic = false
        //不旋转
        self.physicsBody?.allowsRotation = false
        //弹性0
        self.physicsBody?.restitution = 0
    }
}
