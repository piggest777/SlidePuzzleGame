//
//  ViewController.swift
//  SlidePuzzleGame
//
//  Created by Denis Rakitin on 2019-11-09.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLbl: UILabel!
    
    var gameViewWidth: CGFloat!
    var blockWidth: CGFloat!
    var xCen: CGFloat!
    var yCen: CGFloat!
    
    var blocksArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    
    var timeCount: Int = 0
    var gameTimer: Timer = Timer()
    
    var empty: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBlocks()
        self.resetBtnPressed(Any.self)
    }

    func makeBlocks() {
        
        blocksArray = []
        centersArray = []
        
           gameViewWidth = gameView.frame.size.width
            blockWidth = gameViewWidth/4
            
            xCen = blockWidth/2
            yCen = blockWidth/2
        
        var labelNum: Int = 1
        
            for _ in 0..<4 {
                for _ in 0..<4 {

                    let blockFrame = CGRect(x: 0, y: 0, width: blockWidth - 4, height: blockWidth - 4)
                    let block: MyLabel = MyLabel(frame: blockFrame)
                    
                    block.isUserInteractionEnabled = true
                    
                    let thisCenter = CGPoint(x: xCen, y: yCen)
                           
                    block.center = thisCenter
                    block.originalCen = thisCenter
                    centersArray.add(thisCenter)
                    block.text = String(labelNum)
                    
                    labelNum += 1
                    
                    block.textAlignment = NSTextAlignment.center
                    block.font = UIFont.systemFont(ofSize: 24)
                           
                    block.backgroundColor = UIColor.darkGray
                    gameView.addSubview(block)
                    blocksArray.add(block)
                    
                    xCen += blockWidth
                }
                xCen = blockWidth / 2
                yCen = yCen + blockWidth
            }
        let lastBlock = blocksArray[15] as! MyLabel
        lastBlock.removeFromSuperview()
        blocksArray.removeObject(at: 15)
    }
    
    func randomizeAction() {
        let tempCentersArray = centersArray.mutableCopy() as! NSMutableArray
        
        for anyBlock in blocksArray {
            let randomIndex : Int = Int(arc4random()) % tempCentersArray.count
            let randomCenter: CGPoint = tempCentersArray[randomIndex] as! CGPoint
            
            (anyBlock as! MyLabel).center = randomCenter
            tempCentersArray.removeObject(at: randomIndex)
        }
        empty = (tempCentersArray[0] as! CGPoint)
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        randomizeAction()
        timeCount = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector (timerAction), userInfo: nil, repeats: true)
    
    }
    
    @objc func timerAction() {
        timeCount += 1
        timerLbl.text = String.init(format: "%02d\"", timeCount)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch: UITouch = touches.first!
        
        if (blocksArray.contains(myTouch.view as Any)) {
            let touchView: MyLabel = (myTouch.view)! as! MyLabel
            let xDif: CGFloat = touchView.center.x - empty.x
            let yDif:CGFloat = touchView.center.y - empty.y
            
            let distance: CGFloat = sqrt(pow(xDif, 2) + pow(yDif, 2))
            if distance == blockWidth {
                let temporaryCenter: CGPoint = touchView.center
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                touchView.center = empty
                UIView.commitAnimations()
                
                if touchView.originalCen == empty {
                    touchView.backgroundColor = UIColor.green
                } else {
                    touchView.backgroundColor = UIColor.darkGray
                }
                
                empty = temporaryCenter
            }
         }
    }
}

class MyLabel: UILabel {
    var originalCen: CGPoint!
}
