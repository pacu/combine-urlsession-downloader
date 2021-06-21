import XCTest
@testable import combine_urlsession_downloader
import Combine
final class CombineUrlSessionDownloaderTests: XCTestCase {
    
    var cancellable = [AnyCancellable]()
    func testSuccess() throws {
        
        let downloadExpectation = XCTestExpectation(description: "Download expectation")
        let url = URL(string: "https://images.unsplash.com/photo-1554773228-1f38662139db")!
        URLSession.shared.downloadTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink { failure in
                switch failure
                {
                case .failure(let failure):
                    XCTFail("failed: \(failure)")
                case .finished:
                    break
                }
            } receiveValue: { (url, response) in
                downloadExpectation.fulfill()
                do {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        XCTFail("HTTP CALL DOES NOT HAVE AN HTTPURLResonse")
                        return
                    }
                    XCTAssertTrue(httpResponse.statusCode >= 200)
                    XCTAssertTrue(httpResponse.statusCode < 300)
                    
                    let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                    XCTAssertNotNil(attr)
                    XCTAssertTrue(response.expectedContentLength > 0)
                } catch {
                    XCTFail("failed to open file: \(error)")
                }
            }
            .store(in: &self.cancellable)
        
        wait(for: [downloadExpectation], timeout: 10)
    }
    
    func testFailure() throws {
        
        let downloadExpectation = XCTestExpectation(description: "Download expectation")
        let url = URL(string: "https://images.unsplash.com/this-probably-does-not-exist")!
        URLSession.shared.downloadTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink { failure in
                downloadExpectation.fulfill()
                switch failure
                {
                case .failure:
                    XCTAssertTrue(true)
                case .finished:
                    break
                }
            } receiveValue: { (url, response) in
                downloadExpectation.fulfill()
                guard let httpResponse = response as? HTTPURLResponse else {
                    XCTFail("HTTP CALL DOES NOT HAVE AN HTTPURLResonse")
                    return
                }
                XCTAssertTrue(httpResponse.statusCode >= 400)
                XCTAssertTrue(httpResponse.statusCode < 500)
                
            }
            .store(in: &self.cancellable)
        
        wait(for: [downloadExpectation], timeout: 10)
    }
}
