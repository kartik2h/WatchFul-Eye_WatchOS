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
                AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: 5.0)
            print("Recording started")
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }


    @objc func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           if flag {
               print("Recording finished")
               sendRecordedAudio(audioUrl: audioRecorder!.url, apiUrl: URL(string: "https://8944g8jrna.execute-api.us-east-2.amazonaws.com/audioAPI/audioProcessing")!)
               print("Recording saved to: \(audioRecorder?.url.path)")
               print("Recording saved to: \(audioRecorder?.url)")
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
    
    func sendRecordedAudio(audioUrl: URL, apiUrl: URL) {
        let audioData = try! Data(contentsOf: audioUrl)
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"audio\"; filename=\"recording.wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending audio: \(error.localizedDescription)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Unexpected status code: \(response.statusCode)")
                return
            }
            if let data = data {
                print("Audio sent successfully")
                print("Server response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            }
        }
        task.resume()
    }

//    func compressAudioFile(audioUrl: URL) -> URL {
//        let asset = AVURLAsset(url: audioUrl)
//        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)!
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let compressedAudioFilename = "compressed_\(audioUrl.lastPathComponent)"
//        let compressedAudioUrl = URL(fileURLWithPath: documentsPath).appendingPathComponent(compressedAudioFilename)
//
//        exportSession.outputURL = compressedAudioUrl
//        exportSession.outputFileType = AVFileType.m4a
//
//        let startTime = CMTime(seconds: 0, preferredTimescale: 1000)
//        let endTime = CMTime(seconds: asset.duration.seconds, preferredTimescale: 1000)
//        let timeRange = CMTimeRange(start: startTime, end: endTime)
//        exportSession.timeRange = timeRange
//
//        let group = DispatchGroup()
//        group.enter()
//
//        exportSession.exportAsynchronously {
//            switch exportSession.status {
//            case .completed:
//                print("Compression succeeded: \(compressedAudioUrl.path)")
//            case .cancelled:
//                print("Compression cancelled")
//            case .failed:
//                print("Compression failed: \(exportSession.error?.localizedDescription ?? "N/A")")
//            default:
//                break
//            }
//            group.leave()
//        }
//
//        group.wait()
//
//        return compressedAudioUrl
//    }

    
//    func compressAudioFile(_ audioUrl: URL) -> URL {
//        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.m4a")
//        let audioFile = try! AVAudioFile(forReading: audioUrl)
//        let audioFormat = audioFile.processingFormat
//        let audioFrameCount = UInt32(audioFile.length)
//        let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)!
//        try! audioFile.read(into: audioFileBuffer)
//        let audioConverter = AVAudioConverter(from: audioFormat, to: AVAudioFormat.init(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 1, interleaved: true)!)
//        let outputFormat = audioConverter.outputFormat(for: audioFileBuffer.format)
//        let audioConverterBuffer = AVAudioCompressedBuffer(format: audioConverter!.outputFormat(for: audioFileBuffer.format), packetCapacity: audioFrameCount / 16, maximumPacketSize: 0)
//        var error: NSError?
//        audioConverter!.convert(to: audioConverterBuffer, error: &error) { (inputPacketCount, outStatus) -> AVAudioBuffer? in
//            if outStatus.pointee != .haveData {
//                return nil
//            }
//            return audioFileBuffer
//        }
//        try! audioConverterBuffer.dataRepresentation().write(to: outputUrl)
//        return outputUrl
//    }
    
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

