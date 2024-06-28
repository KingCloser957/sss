//
//  FileManager+Helpers.swift
//  Maodou
//
//  Created by huangrui on 2024/5/27.
//

import Foundation

public extension FileManager {

    var cacheDir: URL? {
        urls(for: .cachesDirectory, in: .userDomainMask).last
    }

    var docsDir: URL? {
        urls(for: .documentDirectory, in: .userDomainMask).last
    }

    var torDir: URL? {
        guard let url = cacheDir?.appendingPathComponent("tor", isDirectory: true) else {
            return nil
        }

        try? createSecureDirIfNotExists(at: url)

        return url
    }

    var authDir: URL? {
        guard let url = torDir?.appendingPathComponent("auth", isDirectory: true) else {
            return nil
        }
        try? createSecureDirIfNotExists(at: url)

        return url
    }

    func createSecureDirIfNotExists(at url: URL) throws {
        if fileExists(atPath: url.path) {
            if !((try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false) {
                try removeItem(at: url)
            }
        }
        if !fileExists(atPath: url.path) {
            try createDirectory(
                at: url, withIntermediateDirectories: true,
                attributes: [.posixPermissions: NSNumber(value: 0o700)])
        }
    }
    func sizeOfItem(atPath path: String) -> Int64? {
        return (try? attributesOfItem(atPath: path))?[.size] as? Int64
    }
}

