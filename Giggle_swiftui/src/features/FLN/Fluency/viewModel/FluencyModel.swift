import AVFoundation
import SoundAnalysis

func classifySound(completion: @escaping (Double) -> Void) {
    var audioFileAnalyzer: SNAudioFileAnalyzer?
    let observer = ResultsObserver { finalResult in
        completion(finalResult)
    }
    let fileName = SharedData.shared.sharedVariable
    let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask
    ).first!
    let audioFileURL = documentsDirectory.appendingPathComponent(fileName ?? "")
    print(audioFileURL)
    do {
        audioFileAnalyzer = try SNAudioFileAnalyzer(url: audioFileURL)

        let request = try SNClassifySoundRequest(
            mlModel: FSoundClassifier().model)

        try audioFileAnalyzer?.add(request, withObserver: observer)

        audioFileAnalyzer?.analyze()
    } catch {
        print(
            "Error during sound classification setup: \(error.localizedDescription)"
        )
        completion(0.0)
    }
}

class ResultsObserver: NSObject, SNResultsObserving {
    var lowSum: Double = 0.0
    var intermediateSum: Double = 0.0
    var highSum: Double = 0.0
    var lowCount: Int = 0
    var intermediateCount: Int = 0
    var highCount: Int = 0
    private let completion: (Double) -> Void

    init(completion: @escaping (Double) -> Void) {
        self.completion = completion
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first
        else { return }

        let formattedTime = String(
            format: "%.2f", result.timeRange.start.seconds)
        let percent = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", percent)

        // Categorize confidence values
        switch classification.identifier {
        case "low":
            lowSum += percent
            lowCount += 1
        case "intermediate":
            intermediateSum += percent
            intermediateCount += 1
        case "high":
            highSum += percent
            highCount += 1
        default:
            break
        }

        let resultString =
            "\(classification.identifier): \(percentString) confidence at \(formattedTime)s"
        print(resultString)
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
        completion(0.0)
    }

    func requestDidComplete(_ request: SNRequest) {
        let lowAverage = lowCount > 0 ? lowSum / Double(lowCount) : 0.0
        let intermediateAverage = intermediateCount > 0 ? intermediateSum / Double(intermediateCount) : 0.0
        let highAverage = highCount > 0 ? highSum / Double(highCount) : 0.0

        let finalResult = (lowAverage + intermediateAverage + highAverage) / 3.0

//        print("Low Average: \(lowAverage)%")
//        print("Intermediate Average: \(intermediateAverage)%")
//        print("High Average: \(highAverage)%")
//        print("Final Result: \(finalResult)%")

        completion(finalResult)
    }
}
