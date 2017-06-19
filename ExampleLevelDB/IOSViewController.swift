//
//  ViewController.swift
//  ExampleLevelDB
//
//  Created by Long Cu Huy Hoang on 6/19/17.
//  Copyright © 2017 Long Cu Huy Hoang. All rights reserved.
//

import UIKit
import iOSLevelDB

class IOSViewController: UIViewController {

    @IBOutlet weak var dbLabel: UILabel!
    let database = LevelDB(name: "LongCHH")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        database["LongCHH"] = "store"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getDB(_ sender: Any) {
        dbLabel.text = database["LongCHH"]
    }

}

