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
    var organizedEvents: [HistoricalEvent]
    
    
    // Loading the data from a plist file
    required init?(coder aDecoder: NSCoder) {
        do {
            dictionary = try PlistConvertor.dictionary(fromFile: "EventsList", ofType: "plist")
            organizedEvents = EventManager.dictionaryUnarchiver(fromDictionary: dictionary)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display events
    func displayEvents() {
        
        let eventPack = EventPack.provideEventPack(organizedEvents)
        event1.text = eventPack.event1.event
        event2.text = eventPack.event2.event
        event3.text = eventPack.event3.event
        event4.text = eventPack.event4.event
    }

}

