//
//  CachedAsyncThumbnail.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 09/12/2023.
//

import QuickLookThumbnailing
import UIKit

public class CachedAsyncThumbnail: CachedAsyncImage
{
    let size: CGSize
    let scale: CGFloat

    internal init(url: URL, size: CGSize, scale: CGFloat) throws
    {
        self.size = size
        self.scale = scale
        try super.init(url: url)
    }
    
    public override var imagePath: String{
        get async throws {
            let _ = try await super.imagePath
            let pathExtension = fileURL.pathExtension
            let lastPathComponent = fileURL.deletingPathExtension().lastPathComponent.appending("_thumb")
            let thumbnailURL = fileURL.deletingLastPathComponent().appending(path: lastPathComponent, directoryHint: .notDirectory).appendingPathExtension(pathExtension)
            if !FileManager.default.fileExists(atPath: thumbnailURL.path())
            {
                    // Create the thumbnail request.
                    let request = QLThumbnailGenerator.Request(fileAt: fileURL,
                                                               size: size,
                                                               scale: scale,
                                                               representationTypes: .all)
                    
                    // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
                    let generator = QLThumbnailGenerator.shared
                try await generator.saveBestRepresentation(for: request, to: thumbnailURL, contentType: UTType.png.identifier)
            }
            return thumbnailURL.path
        }
    }
}
