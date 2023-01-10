//
//  LoadImageCommentsFromRemoteUseCase.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 12/30/22.
//

import XCTest
import EssentialFeed

final class ImageCommentsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJSON([])
        
        let samples = [199, 150, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentMapper.map(json, response: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidData = Data("Invalid data".utf8)
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentMapper.map(invalidData, response: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_deliversNoItemOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            let result = try ImageCommentMapper.map(emptyListJSON, response: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }
    
    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username"
        )
        
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "another username"
        )
        
        let json = makeItemsJSON([item1.json, item2.json])
        let samples = [200, 201, 250, 280, 299]
        
        try samples.forEach { code in
            let result = try ImageCommentMapper.map(json, response: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }
    
    // MARK: - Helpers
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        
        let json = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ].compactMapValues { $0 }
        
        return (item, json)
        
    }
}
