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
    
        var audioRecorder: AVAudioRecorder!
        var recordingTimer: Timer!
        var recordingDuration: TimeInterval = 5 // specify the duration of the recording
        
        func requestRecordingPermission() {
            // set up the audio session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try audioSession.setActive(true)
                audioSession.requestRecordPermission { (allowed) in
                    if allowed {
                        // start recording
                        self.startRecording()
                    } else {
                        print("Audio recording permission denied")
                    }
                }
            } catch {
                print("Error setting up audio session")
            }
        }
        
        func startRecording() {
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
            
            // set up the audio recorder
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                // start the recording timer
                recordingTimer = Timer.scheduledTimer(withTimeInterval: recordingDuration, repeats: false, block: { (timer) in
                    self.stopRecording()
                })
            } catch {
                print("Error setting up audio recorder")
            }
        }
        
        func stopRecording() {
            audioRecorder.stop()
            postAudioToAPI()
            recordingTimer.invalidate()
        }
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            print("Audio recording finished")
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
    
    func postAudioToAPI() {
        guard let audioFileURL = audioRecorder?.url else {
            print("Error: Audio file not found.")
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from: Date())
        
        // Set up the request
        let bucketName = "storeaudiofiles-watchfuleye"
        let fileName = "\(dateString)_recording.wav"
        let url = URL(string: "https://1mj1i5c19c.execute-api.us-east-2.amazonaws.com/dev/\(bucketName)/\(fileName)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue("audio/wav", forHTTPHeaderField: "Content-Type")

        // Set the HTTP body
        let body = try! Data(contentsOf: audioFileURL)
        request.httpBody = body

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("Error: Invalid server response")
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("Error: Server returned status code \(response.statusCode)")
                return
            }

            // Success
            print("Audio file uploaded successfully")
        }

        task.resume()
    }

    
//    func postAudioToAPI() {
//        guard let audioFileURL = audioRecorder?.url else {
//            print("Error: Audio file not found.")
//            return
//        }
//
//        // Set up the request
//        let url = URL(string: "https://1mj1i5c19c.execute-api.us-east-2.amazonaws.com/dev/storeaudiofiles-watchfuleye/recording.wav")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//
//        // Set the content type and boundary
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // Set the HTTP body
//        let body = NSMutableData()
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.wav\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
//        body.append(try! Data(contentsOf: audioFileURL))
//        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = body as Data
//
//        // Set the authorization token if needed
//        // request.setValue("Bearer YOUR_AUTHORIZATION_TOKEN", forHTTPHeaderField: "Authorization")
//
//        // Send the request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                print("Error: \(error!)")
//                return
//            }
//
//            guard let data = data, let response = response as? HTTPURLResponse else {
//                print("Error: Invalid server response")
//                return
//            }
//
//            guard (200...299).contains(response.statusCode) else {
//                print("Error: Server returned status code \(response.statusCode)")
//                return
//            }
//
//            // Success
//            print("Audio file uploaded successfully")
//        }
//
//        task.resume()
//    }

}
//    var audioRecorder: AVAudioRecorder?
//    var recordingDuration = 5.0 // set recording duration
//
//    func startRecording() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .default)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//            audioSession.requestRecordPermission { [self] allowed in
////                guard let self = self else { return }
//                if allowed {
//                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//                    let filePath = documentsPath.appendingPathComponent("recording.wav")
//                    let url = URL(fileURLWithPath: filePath)
//                    let settings: [String: Any] = [
//                        AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                        AVSampleRateKey: 44100,
//                        AVNumberOfChannelsKey: 1,
//                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//                    ]
//                    do {
//                        self.audioRecorder = try AVAudioRecorder(url: url, settings: settings)
//                        self.audioRecorder?.delegate = self
//                        self.audioRecorder?.record(forDuration: self.recordingDuration)
//                        print("Started Recording")
//                    } catch {
//                        print("Error Setting Up Audio Recorder: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("Audio recording permission not granted")
//                }
//            }
//        } catch {
//            print("Error Setting Up Audio Session: \(error.localizedDescription)")
//        }
//    }
//
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        print("audioRecorderDidFinishRecording called")
//        if flag {
//            print("Finished Recording")
//            postAudioToAPI()
//        } else {
//            print("Error Recording Audio")
//        }
//        self.audioRecorder = nil // set audioRecorder to nil to release the memory
//    }
//
//    func postAudioToAPI() {
//        // code for posting audio to API
//        print("postAudioToAPI called")
//    }

