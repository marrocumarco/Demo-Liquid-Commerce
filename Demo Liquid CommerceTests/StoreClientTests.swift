//
//  Demo_Liquid_CommerceTests.swift
//  Demo Liquid CommerceTests
//
//  Created by Marco Marrocu on 17/10/2023.
//

import XCTest
@testable import Demo_Liquid_Commerce
final class StoreClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchProductsBaseAuth_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let products = try await client.fetchProducts(1)
        XCTAssert(!products.isEmpty)
    }
    
    func testFetchCategoriesBaseAuth_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let categories = try await client.fetchCategories()
        XCTAssert(!categories.isEmpty)
    }
    
    func testFetchProductsOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let products = try await client.fetchProducts(1)
        XCTAssert(!products.isEmpty)
        
    }
    
    func testFetchCategoriesOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let categories = try await client.fetchCategories()
        XCTAssert(!categories.isEmpty)
    }
    
    func testLogin_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let user = try await client.login("pinco pallino", password: "pinco.pallino")
    }
    
    func testCachedAsyncImage_success() async throws
    {
        let imagePath = try await CachedAsyncImage(url: URL(string: "https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png")!).imagePath
        
        XCTAssert(FileManager.default.fileExists(atPath: imagePath))
    }
}
