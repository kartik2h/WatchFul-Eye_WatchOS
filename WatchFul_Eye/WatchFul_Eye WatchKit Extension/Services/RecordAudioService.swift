//
//  RecordVoiceService.swift
//  WatchFul_Eye WatchKit App
//
//  Created by Megh Patel on 13/02/23.
//

import WatchKit
import Foundation
import AVFoundation

class RecordAudioService: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?
    var isRecording: Bool = false
    
    func requestPermissionAndStartRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
            try recordingSession?.setActive(true, options: [])
            
            recordingSession?.requestRecordPermission() { [weak self] allowed in
                guard self != nil else { return }
                DispatchQueue.main.async {
                    if allowed {
                        self?.startRecording()
                        print("Recording permission accepted.")
                    } else {
                        print("Recording permission denied.")
                    }
                }
            }
        } catch {
            print("Failed to set up recording session.")
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let audioFilename = URL(fileURLWithPath: documentsPath).appendingPathComponent("recording.wav")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: 30.0)
            print("Recording started")
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    @objc func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished")
            print("Recording saved to: \(audioRecorder?.url.path)")
        } else {
            print("Recording failed")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error stopping recording: \(error.localizedDescription)")
        }
    }
    
//    func startRecording() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatLinearPCM),
//            AVSampleRateKey: 44100,
//            AVNumberOfChannelsKey: 2,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder?.prepareToRecord()
//            audioRecorder?.record(forDuration: 30.0) // Record for 30 seconds
//            isRecording = true
//            print("Recording audio to: \(audioFilename)")
//        } catch {
//            print("Failed to start audio recording.")
//        }
//    }
    
//    func stopRecording() {
//        audioRecorder?.stop()
//        audioRecorder = nil
//        isRecording = false
//        print("Audio recording stopped.")
//
//        // Save the file
//        if let audioFilename = audioRecorder?.url {
//            do {
//                let fileData = try Data(contentsOf: audioFilename)
//                let documentsDirectory = getDocumentsDirectory()
//                let destinationURL = documentsDirectory.appendingPathComponent(audioFilename.lastPathComponent)
//                try fileData.write(to: destinationURL)
//                print("Audio file saved to: \(destinationURL)")
//            } catch {
//                print("Failed to save audio file.")
//            }
//        }
//    }
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    init() {
//        // Start recording automatically when initializing the AudioRecorder instance
//        requestPermissionAndStartRecording()
//    }
}


//class RecordVoiceService: WKInterfaceController {
//
//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.textVoiceInput()
//        }
//    }
//
//    func textVoiceInput() {
//        print("voice function called")
//        let option2: [String: Any] = [WKAudioRecorderControllerOptionsActionTitleKey: "send",
//                                       WKAudioRecorderControllerOptionsAutorecordKey: true,
//                                       WKAudioRecorderControllerOptionsMaximumDurationKey: 30]
//
//        /* Error: Error Domain=com.apple.watchkit.errors Code=3 "(null)"
//        let string = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
//        let url = NSURL.fileURL(withPath: string!.appending("myRecord.caf"))
//        */
//
//        // Use App Group URL
//        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.huaxia.record")
//        let newUrl = url!.appendingPathComponent("record.wav")
//
//        presentAudioRecorderController(withOutputURL:newUrl , preset: .narrowBandSpeech, options: option2) { (didSave, error) in
//            if error == nil {
//                print("didSave=\(didSave)");
//            } else {
//                print("error=\(error!)")
//            }
//        }
//    }
//
//}



//class RecordController: WKInterfaceController {
//
//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.recordVoice()
//        }
//    }
//
//    func recordVoice() {
//        let options: [String: Any] = [
//            WKAudioRecorderControllerOptionsActionTitleKey: "send",
//            WKAudioRecorderControllerOptionsAutorecordKey: true,
//            WKAudioRecorderControllerOptionsMaximumDurationKey: 30
//        ]
//
//        let fileManager = FileManager.default
//        guard let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.huaxia.record")?.appendingPathComponent("record.wav") else {
//            print("Failed to get URL for recorded voice file")
//            return
//        }
//
//        presentAudioRecorderController(withOutputURL: url, preset: .narrowBandSpeech, options: options) { didSave, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard didSave else {
//                print("Recording was not saved")
//                return
//            }
//
//            self.uploadVoiceFile(url: url)
//        }
//    }
//
//    func uploadVoiceFile(url: URL) {
//        // Initialize the S3 client
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "your_access_key", secretKey: "your_secret_key")
//        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
//        AWSS3.register(with: configuration, forKey: "defaultKey")
//
//        // Create a unique key for the file in your bucket
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
//        let key = "recorded-voice-\(dateFormatter.string(from: Date())).wav"
//
//        // Read the contents of the recorded voice file into memory
//        guard let data = try? Data(contentsOf: url) else {
//            print("Failed to read data from recorded voice file")
//            return
//        }
//
//        // Configure the upload request
//        let request = AWSS3TransferManagerUploadRequest()!
//        request.bucket = "your_bucket_name"
//        request.key = key
//        request.body = url
//        request.acl = .publicRead
//
//        // Upload the file to S3
//        let transferManager = AWSS3TransferManager.default()
//        transferManager.upload(request).continueWith { task in
//            if let error = task.error {
//                print("Error uploading recorded voice file: \(error.localizedDescription)")
//            } else {
//                print("Recorded voice file uploaded successfully")
//            }
//
//            return nil
//        }
//    }
//}

