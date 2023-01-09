//
//  LoadImageCommentsFromRemoteUseCase.swift
//  EssentialFeedTests
//
//  Created by Mohammadreza on 12/30/22.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCase: XCTestCase {
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 150, 300, 400, 500]
        samples.enumerated().forEach { index, value in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: value, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let invalidData = Data("Invalid data".utf8)
                client.complete(withStatusCode: code, data: invalidData, at: index)
            })
        }
    }
    
    func test_load_deliversNoItemOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success([]), when: {
                let emptyListJSON = makeItemsJSON([])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            })
        }
    }
    
    func test_load_deliversNoItemOn2xxHTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
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
        
        let items = [item1.model, item2.model]
        
        let samples = [200, 201, 250, 280, 299]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemsJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
        
    }
    
    // MARK: - Helpers

    private func expect(_ sut: RemoteImageCommentLoader,
                        toCompleteWith expectedResult: RemoteImageCommentLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(receivedItems)):
                XCTAssertEqual(receivedItems, receivedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteImageCommentLoader.Error), .failure(expectedError as RemoteImageCommentLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
                
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
        
    }
    
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: RemoteImageCommentLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    
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
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func failure(_ error: RemoteImageCommentLoader.Error) -> RemoteImageCommentLoader.Result {
        return .failure(error)
    }

}
