////
////  RecordAudioAWS.swift
////  WatchFul_Eye WatchKit App
////
////  Created by Megh Patel on 20/02/23.
////
//
////import AWSS3
////import AWSCore
//import AVFoundation
//
//class RecordAudioAWSService: NSObject, AVAudioRecorderDelegate {
//    var audioRecorder: AVAudioRecorder!
//
//    func startRecording() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .default)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            let audioFilename = URL(fileURLWithPath: documentsPath).appendingPathComponent("recording.wav")
//
//            let settings = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: 44100,
//                AVNumberOfChannelsKey: 2,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
//
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//        } catch {
//            print("Error setting up audio recording: \(error.localizedDescription)")
//        }
//    }
//
//    func stopRecording() {
//        audioRecorder.stop()
//
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "YOUR_ACCESS_KEY", secretKey: "YOUR_SECRET_KEY")
//        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
//
//        let transferUtility = AWSS3TransferUtility.default()
//
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let audioFilename = URL(fileURLWithPath: documentsPath).appendingPathComponent("recording.wav")
//        let uploadRequest = AWSS3TransferManagerUploadRequest()!
//        uploadRequest.bucket = "YOUR_BUCKET_NAME"
//        uploadRequest.key = "recording.wav"
//        uploadRequest.body = audioFilename
//
//        transferUtility.upload(uploadRequest).continueWith { (task) -> Any? in
//            if let error = task.error {
//                print("Error uploading recording to S3: \(error.localizedDescription)")
//            } else {
//                print("Recording uploaded to S3")
//            }
//            return nil
//        }
//    }
//
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            print("Recording failed")
//        }
//    }
//}
