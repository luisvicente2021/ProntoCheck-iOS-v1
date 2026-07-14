import CoreML
import UIKit

final class ArcFaceEmbeddingProvider: FaceEmbeddingProviderProtocol {

    private let model: FaceEmbedding

    init() throws {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .all

        model = try FaceEmbedding(configuration: configuration)
    }

    func generateEmbedding(
        from faceImage: UIImage
    ) async throws -> [Float] {
        print("✅ ArcFace provider called")

        guard let pixelBuffer = faceImage.toPixelBuffer(
            width: 112,
            height: 112
        ) else {
            print("❌ Could not create pixel buffer")
            throw FaceRecognitionError.invalidModelInput
        }

        print("✅ Pixel buffer created")

        let output = try await model.prediction(
            faceImage: pixelBuffer
        )

        print("✅ Core ML prediction completed")

        let embeddingArray = output.embedding

        let embedding = (0..<embeddingArray.count).map {
            embeddingArray[$0].floatValue
        }

        print("✅ Embedding count:", embedding.count)
        print("First values:", Array(embedding.prefix(5)))

        return embedding
    }
}
