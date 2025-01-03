import AVFoundation
import SoundAnalysis

func classifySound() {
    var audioFileAnalyzer: SNAudioFileAnalyzer?
    let observer = ResultsObserver()
    let fileName = SharedData.shared.sharedVariable
    let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask
    ).first!
    let audioFileURL = documentsDirectory.appendingPathComponent(fileName ?? "")
    print(audioFileURL)
    do {
        // Initialize the audio file analyzer
        audioFileAnalyzer = try SNAudioFileAnalyzer(url: audioFileURL)

        let request = try SNClassifySoundRequest(
            mlModel: FSoundClassifier().model)

        try audioFileAnalyzer?.add(request, withObserver: observer)

        audioFileAnalyzer?.analyze()
    } catch {
        print(
            "Error during sound classification setup: \(error.localizedDescription)"
        )
    }
}
class ResultsObserver: NSObject, SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first
        else { return }

        let formattedTime = String(
            format: "%.2f", result.timeRange.start.seconds)
        let percent = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", percent)

        let resultString =
            "\(classification.identifier): \(percentString) confidence at \(formattedTime)s"
        print(resultString)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
