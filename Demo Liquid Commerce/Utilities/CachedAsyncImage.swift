//
//  CachedAsyncImage.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 08/12/2023.
//

import Foundation

public struct CachedAsyncImage
{
    internal init(url: URL) throws {
        self.url = url
        self.directoryURL = FileManager.default.temporaryDirectory.appendingPathComponent("images", conformingTo: .directory)
        self.fileURL = self.directoryURL.appendingPathComponent(url.lastPathComponent, conformingTo: .fileURL)
        if !FileManager.default.fileExists(atPath: self.directoryURL.path)
        {
            try FileManager.default.createDirectory(atPath: self.directoryURL.path, withIntermediateDirectories: true)
        }
    }
    
    private let url: URL
    private let fileURL: URL
    private let directoryURL: URL
    public var imagePath: String
    {
        get async throws {
            if !FileManager.default.fileExists(atPath: fileURL.path)
            {
                let (data, _)  = try await URLSession.shared.data(from: url)
                try data.write(to: fileURL)
            }
            return fileURL.path
        }
    }
}
