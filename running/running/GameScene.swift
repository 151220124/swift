//
//  GameScene.swift
//  running
//
//  Created by wuha o on 2018/12/17.
//  Copyright © 2018年 wuha o. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate,ProtocolMainScene {
    lazy var runner = porkour()
    lazy var unitset = Unitset()
    
    //距离的变量
    var distance :CGFloat = 0.0
    //人物的移动速度
    var moveSpeed:CGFloat = 15
    //人物的最大速度
    var maxSpeed :CGFloat = 50.0
    //判断游戏平台是否稳定生产
    var lastDis:CGFloat = 0.0
    //是否game over
    var isLose = false
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx:0,dy: -5)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    
        self.physicsBody?.categoryBitMask = kick.scene
    
        self.physicsBody?.isDynamic = false
        
        let skyColor = SKColor(red:113/255,green:197/255,blue:207/255,alpha:1)
        self.backgroundColor = skyColor
        
        //给跑酷小人定一个初始位置
        runner.position = CGPoint(x:200,y: 400)
        //将跑酷小人显示在场景中
        self.addChild(runner)
        //将平台工厂加入视图
        self.addChild(unitset)
       
        unitset.sceneWidth = self.frame.width
     
        unitset.delegate = self
 
        unitset.createGround(midNum: 3, x: 0, y: 200)
    }
    
    //触碰屏幕跳跃
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)  {
        if isLose {
            reSet()
        }else{
            runner.jump()
        }
    }
    
    //离开平台时记录起跳点
    func didEndContact(contact: SKPhysicsContact!){
        runner.jumpStart = runner.position.y
    }
    
    //碰撞检测方法
    func didBeginContact(contact: SKPhysicsContact!) {
        //小人和台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)
            == (kick.platform | kick.runner){
            //假设平台不会下沉，用于给后面判断平台是否会被熊猫震的颤抖
            var isinsameheight = false
            //用于判断接触平台后能否转变为跑的状态，默认值为false不能转换
            var canRun = false
            //如果碰撞体A是平台
            if contact.bodyA.categoryBitMask == kick.platform {
                //如果是会下沉的平台
                if (contact.bodyA.node as! ground).isinsameheight {
                    isinsameheight = true
                    //让平台接收重力影响
                    contact.bodyA.node?.physicsBody?.isDynamic = true
                    //不将碰撞效果取消，平台下沉的时候会跟着熊猫跑这不是我们希望看到的，
                    //大家可以将这行注释掉看看效果
                    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
                    //如果是会升降的平台
                }
                
                if (contact.bodyB.node?.position.y)! > contact.bodyA.node!.position.y {
                    canRun=true
                }
                //如果碰撞体B是平台
            }else if contact.bodyB.categoryBitMask == kick.platform  {
                if (contact.bodyB.node as! ground).isinsameheight {
                    contact.bodyB.node?.physicsBody?.isDynamic = true
                    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
                    isinsameheight = true
                }
                if (contact.bodyA.node?.position.y)! > (contact.bodyB.node!.position.y) {
                    canRun=true
                }
            }
            
            //判断是否打滚
            runner.jumpEnd = runner.position.y
            if runner.jumpEnd-runner.jumpStart <= -70 {
                runner.roll()
                //如果平台下沉就不让它被震得颤抖一下
                if !isinsameheight {
                    downAndUp(node: contact.bodyA.node!)
                    downAndUp(node: contact.bodyB.node!)
                }
            }else{
                if canRun {
                    runner.run()
                }
            }
        }
        
        //如果人物和场景边缘碰撞
        if (contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask)
            == (kick.scene | kick.runner) {
            print("游戏结束")
            isLose = true
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //如果小人出现了位置偏差，就逐渐恢复
        if runner.position.x < 200 {
            let x = runner.position.x + 1
            runner.position = CGPoint(x:x,y: runner.position.y)
        }
        if !isLose {
            lastDis -= moveSpeed
            //速度以5为基础，以跑的距离除以2000为增量
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            //将速度控制在maxSpeed
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            //如果移动速度小于新的速度就改变
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis <= 0 {
                unitset.createGroundRandom()
            }
            unitset.move(speed:self.moveSpeed)
            distance += moveSpeed
        }
        
    }
    
    func onGetData(dist:CGFloat){
        self.lastDis = dist
    }
    
    //up and down 方法(平台震动一下)
    func downAndUp(node :SKNode,down:CGFloat = -50,downTime:Double=0.05,
                   up:CGFloat=50,upTime:Double=0.1){
        //下沉动作
        let downAct = SKAction.moveBy(x: 0, y: down, duration: downTime)
        //上升动过
        let upAct = SKAction.moveBy(x: 0, y: up, duration: upTime)
        //下沉上升动作序列
        let downUpAct = SKAction.sequence([downAct,upAct])
        node.run(downUpAct)
    }
    
    //重新开始游戏
    func reSet(){
        //重置isLose变量
        isLose = false
        //重置小人位置
        runner.position = CGPoint(x:200,y: 400)
        //重置移动速度
        moveSpeed  = 15.0
        //重置跑的距离
        distance = 0.0
        //重置首个平台完全进入游戏场景的距离
        lastDis = 0.0
        //平台工厂的重置方法
        unitset.reSet()
        //创建一个初始的平台给熊猫一个立足之地
        unitset.createGround(midNum: 3, x: 0, y: 200)
    }
}
