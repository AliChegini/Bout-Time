//
//  ViewController.swift
//  BoutTime
//
//  Created by Ehsan on 11/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var event3: UILabel!
    @IBOutlet weak var event4: UILabel!
    
    
    var dictionary: [String: Any] = [:]
    var events: [HistoricalEvent]
    
    
    // Loading the data from a plist file
    required init?(coder aDecoder: NSCoder) {
        do {
            dictionary = try PlistConvertor.dictionary(fromFile: "EventsList", ofType: "plist")
            events = EventManager.dictionaryUnarchiver(fromDictionary: dictionary)
            //print(events[0].event)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Start a new round
    
    // Populate the events
    
    // validate the answer
    
    // show score
    

}

