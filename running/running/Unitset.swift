//
//  Unitset.swift
//  running
//
//  Created by wuha o on 2018/12/20.
//  Copyright © 2018年 wuha o. All rights reserved.
//

import SpriteKit

class Unitset: SKNode {
    
    let ground1 = SKTexture(imageNamed: "ground1")
    
    let ground2 = SKTexture(imageNamed: "ground2")
    
    let ground3 = SKTexture(imageNamed: "ground3")
    
    
    var grounds = [ground]()
    
    
    var sceneWidth:CGFloat = 0
    
    var delegate:ProtocolMainScene?
    
    //随机生成地面高度差
    func createGround(midNum:UInt32,x:CGFloat,y:CGFloat){
        let ground = self.createGround(isRandom: false, midNum: midNum, x: x, y: y)
        delegate?.onGetData(dist: ground.width - sceneWidth)
    }
    
    //生成随机位置的地面的方法
    func createGroundRandom(){
    
        let midNum:UInt32 = arc4random()%4 + 1
        
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        
        let x:CGFloat = self.sceneWidth + CGFloat( midNum*50 ) + gap + 100
    
        let y:CGFloat = CGFloat(arc4random()%200 + 200)
    
        let ground = self.createGround(isRandom: true, midNum: midNum, x: x, y: y)
        //回传距离用于判断什么时候生成新的平台
        delegate?.onGetData(dist: ground.width + x - sceneWidth)
        
    }
    
    func createGround(isRandom:Bool,midNum:UInt32,x:CGFloat,y:CGFloat)->ground{
        //声明一个平台类，用来组装平台。
        let groundx = ground()
        //生成平台的左边零件
        let g1 = SKSpriteNode(texture: ground1)
        //设置中心点
        g1.anchorPoint = CGPoint(x: 0, y: 0.9)
        //生成平台的右边零件
        let g3 = SKSpriteNode(texture: ground3)
        //设置中心点
        g3.anchorPoint = CGPoint(x: 0, y: 0.9)
        
        //声明一个数组来存放平台的零件
        var arrayground = [SKSpriteNode]()
        //将左边零件加入零件数组
        arrayground.append(g1)
        
        //根据传入的参数来决定要组装几个平台的中间零件
        //然后将中间的零件加入零件数组
        for _ in 1...midNum {
            let g2 = SKSpriteNode(texture: ground2)
            g2.anchorPoint = CGPoint(x: 0, y: 0.9)
            arrayground.append(g2)
        }
        //将右边零件加入零件数组
        arrayground.append(g3)
        //将零件数组传入
        groundx.onCreate(arrSprite: arrayground)
        groundx.name="ground"
        //设置平台的位置
        groundx.position = CGPoint(x: x, y: y)
        //放到当前实例中
        self.addChild(groundx)
        //将平台加入平台数组
        grounds.append(groundx)
        return groundx
    }
    
    func move(speed:CGFloat){
        //遍历所有
        for p in grounds{
            //x坐标的变化长生水平移动的动画
            p.position.x -= speed
        }
        //移除平台
        if grounds[0].position.x < -grounds[0].width {
            grounds[0].removeFromParent()
            grounds.remove(at: 0)
        }
    }
    
    //重置方法
    func reSet(){
        //清除所有子对象
        self.removeAllChildren()
        //清空平台数组
        grounds.removeAll(keepingCapacity: false)
    }
}

//定义一个协议，用来接收数据
protocol ProtocolMainScene {
    func onGetData(dist:CGFloat)
}

