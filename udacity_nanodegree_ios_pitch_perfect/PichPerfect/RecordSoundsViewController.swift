//
//  ViewController.swift
//  PichPerfect
//
//  Created by Eduardo Soares Sampaio on 06/03/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordinButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordinButton.isEnabled = false;
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        setRecordButtonsState(isPlaying: true,"Recording audio")
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        setRecordButtonsState(isPlaying: false,"Tap to record")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    private func setRecordButtonsState(isPlaying: Bool,_ message:String){
        recordingLabel.text = message;
        stopRecordinButton.isEnabled = isPlaying;
        recordButton.isEnabled = !isPlaying;
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecordSegue", sender: audioRecorder.url)
        }else{
            showAlert("Error when recorgind audio")
        }
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Pitch Perfect", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordSegue"{
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsViewController.recordedAudioURL = recordAudioURL
        }
    }    
}
