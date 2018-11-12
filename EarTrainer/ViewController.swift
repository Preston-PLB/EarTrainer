//
//  ViewController.swift
//  EarTrainer
//
//  Created by Baxter, Preston L on 11/2/18.
//  Copyright © 2018 Baxter, Preston L. All rights reserved.
//

import UIKit
import Beethoven
import Pitchy
import AudioKit

class ViewController: UIViewController {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    var basePitch = 440
    var tolerance = 5
    
    var oscillator = AKOscillator()
    
    
    lazy var pitchEngine: PitchEngine = { [weak self] in
        let config = Config(estimationStrategy: .yin)
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = -30.0
        return pitchEngine
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: impement settings
        basePitch = 440
        tolerance = 5
        
        AudioKit.output = oscillator
        
        do{
          try AudioKit.start()
        }catch{
            AKLog("AudioKit did not start!")
        }
        
        pitchEngine.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decimalFormat(_ precision: Int, _ double: Double) -> String{
        return String(format: "%.\(precision)f", double)
    }


}

extension ViewController: PitchEngineDelegate {
    func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch){
        oscillator.frequency = pitch.frequency
        noteLabel.text = "\(pitch.note.letter)"
        offsetLabel.text = decimalFormat(2, pitch.closestOffset.cents)
        frequencyLabel.text = decimalFormat(2, pitch.frequency)
        if(pitch.closestOffset.cents > Double(tolerance)){
            oscillator.start()
        }else{
            oscillator.stop()
        }
    }
    
    func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }
    
    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine){
        
    }
}

