//===---*- Greatdori! -*---------------------------------------------------===//
//
// ContentView.swift
//
// This source file is part of the Greatdori! open source project
//
// Copyright (c) 2025 the Greatdori! project authors
// Licensed under Apache License v2.0
//
// See https://greatdori.memz.top/LICENSE.txt for license information
// See https://greatdori.memz.top/CONTRIBUTORS.txt for the list of Greatdori! project authors
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftyJSON
import CoreGraphics
import ArgumentParser

@main
struct SpriteMetadataArranger: ParsableCommand {
    @Argument var inputFilePath: String
    @Option(name: [.customShort("o"), .customLong("output")]) var outputFilePath: String
    mutating func run() throws {
        let content = try String(contentsOfFile: inputFilePath, encoding: .utf8)
        let json = JSON(parseJSON: content)
        
        // Simple validation
        guard json[0]["Base"]["m_Name"].string != nil else {
            print("Invalid input.")
            Foundation.exit(1)
        }
        
        var result: [NoteSpriteMetadata] = []
        for (_, obj) in json {
            let base = obj["Base"]
            result.append(.init(
                name: base["m_Name"].stringValue,
                rect: .init(
                    x: base["m_Rect"]["x"].doubleValue,
                    y: base["m_Rect"]["y"].doubleValue,
                    width: base["m_Rect"]["width"].doubleValue,
                    height: base["m_Rect"]["height"].doubleValue
                ),
                offset: .init(x: base["m_Offset"]["x"].doubleValue, y: base["m_Offset"]["y"].doubleValue),
                textureRect: .init(
                    x: base["m_VertexData"]["textureRect"]["x"].doubleValue,
                    y: base["m_VertexData"]["textureRect"]["y"].doubleValue,
                    width: base["m_VertexData"]["textureRect"]["width"].doubleValue,
                    height: base["m_VertexData"]["textureRect"]["height"].doubleValue
                ),
                textureRectOffset: .init(x: base["m_VertexData"]["textureRectOffset"]["x"].doubleValue, y: base["m_VertexData"]["textureRectOffset"]["y"].doubleValue)
            ))
        }
        
        let encoder = PropertyListEncoder()
        try encoder.encode(result).write(to: URL(filePath: outputFilePath))
    }
}
