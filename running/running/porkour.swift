//
//  porkour.swift
//  running
//
//  Created by wuha o on 2018/12/18.
//  Copyright © 2018年 wuha o. All rights reserved.
//

import SpriteKit

enum Status:Int{
    case run=1,jump,jump2,roll;
}

class porkour : SKSpriteNode {
   
    let runAtlas = SKTextureAtlas(named: "run.atlas")
  
    var runFrames = [SKTexture]()

    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
 
    var jumpFrames = [SKTexture]();
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]();
    
    var status = Status.run
    
    var jumpStart:CGFloat = 0.0
    var jumpEnd :CGFloat = 0.0

    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
  
    var jumpEffectFrames = [SKTexture]()
 
    var jumpEffect = SKSpriteNode()
    

     init() {
        let texture = runAtlas.textureNamed("porkour_01")
        let size = texture.size()
        super.init(texture:texture,color:SKColor.white,size:size)
        
        var _:Int
        //填充跑的纹理数组
        for i in 1..<runAtlas.textureNames.count  {
            let tempName = String(format: "tt_run_%.2d", i)
            let runTexture = runAtlas.textureNamed(tempName)
            if runTexture != nil {
                runFrames.append(runTexture)
            }
        }
        //填充跳的纹理数组
        for i in 1..<jumpAtlas.textureNames.count {
            let tempName = String(format: "tt_jump_%.2d", i)
            let jumpTexture = jumpAtlas.textureNamed(tempName)
            if jumpTexture != nil {
                jumpFrames.append(jumpTexture)
            }
        }
        //填充打滚的纹理数组
        for i in 1..<rollAtlas.textureNames.count{
            let tempName = String(format: "tt_%.2d", i)
            let rollTexture = rollAtlas.textureNamed(tempName)
            if rollTexture != nil{
                rollFrames.append(rollTexture)
            }
        }
        //起跳特效
        for i in 1..<jumpEffectAtlas.textureNames.count {
            let tempName = String(format: "jump_effect_%.2d", i)
            let effectexture = jumpEffectAtlas.textureNamed(tempName)
            if effectexture != nil {
                jumpEffectFrames.append(effectexture)
            }
        }
        
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPoint(x:-80,y:-30)
        jumpEffect.isHidden = true
        self.addChild(jumpEffect)
        
        run()
        
        self.zPosition = 30
        
        self.physicsBody = SKPhysicsBody(rectangleOf:texture.size())
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        //弹性
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = kick.runner
        self.physicsBody?.contactTestBitMask = kick.platform | kick.scene
        self.physicsBody?.collisionBitMask = kick.platform
    }
    
    func run(){
        //移除所有的动作
        self.removeAllActions()
        //将当前动作状态设为跑
        self.status = .run
        //通过SKAction.animateWithTextures将跑的文理数组设置为0.05秒切换一次的动画
        // SKAction.repeatActionForever将让动画永远执行
        // self.runAction执行动作形成动画
        self.run(SKAction.repeatForever(
            SKAction.animate(with: runFrames, timePerFrame: 0.05)))
    }
    
    //跳
    func jump (){
        self.removeAllActions()
        if status != Status.jump2 {
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05))
            //施加一个向上的力，让小人跳起来
            self.physicsBody?.velocity = CGVector(dx:0, dy:450)
            if status == Status.jump {
                status = Status.jump2
                self.jumpStart = self.position.y
            }else{
                showJumpEffect()
                status = Status.jump
            }
        }
    }
    
    //打滚
    func roll(){
        self.removeAllActions()
        status = .roll
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05),
                       completion:{() in self.run()})
    }
    
    //起跳特效
    func showJumpEffect(){
        //先将特效取消隐藏
        jumpEffect.isHidden = false
        //利用action播放特效
        let ectAct = SKAction.animate( with: jumpEffectFrames, timePerFrame: 0.05)
        //执行闭包，再次隐藏特效
        let removeAct = SKAction.run({() in
            self.jumpEffect.isHidden = true
        })
        //组成序列Action进行执行
        jumpEffect.run(SKAction.sequence([ectAct,removeAct]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

