import AVFoundation
import CreateMLComponents
import Foundation
import SoundAnalysis
import Speech
import SwiftUI

class SharedData {
    static let shared = SharedData()
    var sharedVariable: String?
}

struct SpeechRecognizer {
    private class SpeechAssist {
        var audioEngine: AVAudioEngine?
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let speechRecognizer = SFSpeechRecognizer()

        // Audio recording properties
        var audioFile: AVAudioFile?
        var recordingURL: URL?

        deinit {
            reset()
        }

        func reset() {
            recognitionTask?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            recognitionRequest = nil
            recognitionTask = nil
            audioFile = nil
        }
    }

    private let assistant = SpeechAssist()

    func record(to speech: Binding<String>) {
        relay(speech, message: "Requesting access")
        canAccess { authorized in
            guard authorized else {
                relay(speech, message: "Access denied")
                return
            }

            relay(speech, message: "Access granted")

            assistant.audioEngine = AVAudioEngine()
            guard let audioEngine = assistant.audioEngine else {
                fatalError("Unable to create audio engine")
            }
            assistant.recognitionRequest =
                SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = assistant.recognitionRequest else {
                fatalError("Unable to create request")
            }
            recognitionRequest.shouldReportPartialResults = true

            do {
                relay(speech, message: "Booting audio subsystem")

                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(
                    .record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(
                    true, options: .notifyOthersOnDeactivation)
                let inputNode = audioEngine.inputNode
                relay(speech, message: "Found input node")

                // Set up audio recording
                let documentsPath = FileManager.default.urls(
                    for: .documentDirectory, in: .userDomainMask)[0]
                let audioFilename =
                    "recording-\(Date().timeIntervalSince1970).wav"
                assistant.recordingURL = documentsPath.appendingPathComponent(
                    audioFilename)

                let recordingFormat = inputNode.outputFormat(forBus: 0)
                guard let recordingURL = assistant.recordingURL else {
                    fatalError("Unable to create recording URL")
                }

                assistant.audioFile = try AVAudioFile(
                    forWriting: recordingURL,
                    settings: recordingFormat.settings)

                inputNode.installTap(
                    onBus: 0, bufferSize: 1024, format: recordingFormat
                ) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                    // Write buffer to audio file
                    try? assistant.audioFile?.write(from: buffer)

                    // Send buffer for speech recognition
                    recognitionRequest.append(buffer)
                }

                relay(speech, message: "Preparing audio engine")
                audioEngine.prepare()
                try audioEngine.start()
                assistant.recognitionTask = assistant.speechRecognizer?
                    .recognitionTask(with: recognitionRequest) {
                        (result, error) in
                        var isFinal = false
                        if let result = result {
                            relay(
                                speech,
                                message: result.bestTranscription
                                    .formattedString)
                            isFinal = result.isFinal
                        }

                        if error != nil || isFinal {
                            audioEngine.stop()
                            inputNode.removeTap(onBus: 0)
                            self.assistant.recognitionRequest = nil
                        }
                    }
            } catch {
                print("Error transcribing audio: " + error.localizedDescription)
                assistant.reset()
            }
        }
    }

    /// Stop transcribing audio and save recording
    func stopRecording() -> URL? {
        let recordingURL = assistant.recordingURL
        if let url = recordingURL {
            let fileName = url.lastPathComponent
            let fileNameString = String(fileName)
            print(fileNameString, " before")

            SharedData.shared.sharedVariable = fileNameString
            print(
                SharedData.shared.sharedVariable ?? "default value",
                " shared variable")
            print("Recording saved to: \(url.path)")
        }
        assistant.reset()
        return recordingURL
    }

    private func canAccess(withHandler handler: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                AVAudioApplication.requestRecordPermission { authorized in
                    handler(authorized)
                }
            } else {
                handler(false)
            }
        }
    }

    private func relay(_ binding: Binding<String>, message: String) {
        binding.wrappedValue = message
    }
}
