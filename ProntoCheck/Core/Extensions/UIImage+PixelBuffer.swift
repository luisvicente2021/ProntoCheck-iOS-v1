//
//  UIImage+PixelBuffer.swift
//  ProntoCheck
//
//  Created by usuario on 14/07/26.
//

import Foundation
import UIKit
import CoreVideo

extension UIImage {

    func toPixelBuffer(
        width: Int,
        height: Int
    ) -> CVPixelBuffer? {
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [:]
        ]

        var optionalPixelBuffer: CVPixelBuffer?

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attributes as CFDictionary,
            &optionalPixelBuffer
        )

        guard status == kCVReturnSuccess,
              let pixelBuffer = optionalPixelBuffer
        else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])

        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }

        guard let normalizedImage = normalizedCGImage else {
            return nil
        }

        context.interpolationQuality = .high
        context.clear(
            CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )

        context.draw(
            normalizedImage,
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )

        return pixelBuffer
    }

    private var normalizedCGImage: CGImage? {
        normalizedForDisplay(mirrorForFrontCamera: false).cgImage
    }

    func normalizedForFaceRecognition() -> UIImage {
           guard imageOrientation != .up else {
               return self
           }

           let format = UIGraphicsImageRendererFormat.default()
           format.scale = 1

           return UIGraphicsImageRenderer(
               size: size,
               format: format
           ).image { _ in
               draw(
                   in: CGRect(
                       origin: .zero,
                       size: size
                   )
               )
           }
       }

    private func normalizedForDisplay(mirrorForFrontCamera: Bool) -> UIImage {
        guard let cgImage else {
            return self
        }

        let targetSize = CGSize(
            width: cgImage.width,
            height: cgImage.height
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale

        let renderer = UIGraphicsImageRenderer(
            size: targetSize,
            format: format
        )

        return renderer.image { context in
            let cgContext = context.cgContext

            switch imageOrientation {
            case .down:
                cgContext.translateBy(x: targetSize.width, y: targetSize.height)
                cgContext.rotate(by: .pi)
            case .left:
                cgContext.translateBy(x: targetSize.width, y: 0)
                cgContext.rotate(by: .pi / 2)
            case .right:
                cgContext.translateBy(x: 0, y: targetSize.height)
                cgContext.rotate(by: -.pi / 2)
            case .upMirrored:
                cgContext.translateBy(x: targetSize.width, y: 0)
                cgContext.scaleBy(x: -1, y: 1)
            case .downMirrored:
                cgContext.translateBy(x: targetSize.width, y: targetSize.height)
                cgContext.scaleBy(x: -1, y: 1)
                cgContext.rotate(by: .pi)
            case .leftMirrored:
                cgContext.translateBy(x: targetSize.height, y: 0)
                cgContext.scaleBy(x: -1, y: 1)
                cgContext.rotate(by: .pi / 2)
            case .rightMirrored:
                cgContext.translateBy(x: 0, y: targetSize.height)
                cgContext.scaleBy(x: -1, y: 1)
                cgContext.rotate(by: -.pi / 2)
            case .up:
                break
            @unknown default:
                break
            }

            if mirrorForFrontCamera {
                cgContext.translateBy(x: targetSize.width, y: 0)
                cgContext.scaleBy(x: -1, y: 1)
            }

            cgContext.draw(
                cgImage,
                in: CGRect(
                    origin: .zero,
                    size: targetSize
                )
            )
        }
    }
}
