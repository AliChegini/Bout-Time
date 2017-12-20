//
//  DisplayWebContent.swift
//  BoutTime
//
//  Created by Ehsan on 19/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import UIKit
import WebKit

class DisplayWebContent: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://www.wikipedia.org")
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) {
                (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.webView.load(request)
                    }
                } else {
                    print("ERROR: \(error!)")
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToGame(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
