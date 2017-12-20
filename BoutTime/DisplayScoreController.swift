//
//  DisplayScoreController.swift
//  BoutTime
//
//  Created by Ehsan on 19/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import UIKit

class DisplayScoreController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    
    var point: Int?
    var roundsPerGame: Int?
    
    // closure defined in prepare segue in ViewController
    var goPlayAgain: ( () -> () )?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        score.text = "\(point!)/\(roundsPerGame!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func playAgain(_ sender: Any) {
        // Closure defined in prepare segue in ViewController
        // It dismisses the current view and call playAgain() function
        self.goPlayAgain?()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
