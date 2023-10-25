//
//  Demo_Liquid_CommerceTests.swift
//  Demo Liquid CommerceTests
//
//  Created by Marco Marrocu on 17/10/2023.
//

import XCTest
@testable import Demo_Liquid_Commerce
final class Demo_Liquid_CommerceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchProducts_success() async throws {
       let client = UnsecureTestClient()
        // Create an expectation for an asynchronous task.
        let products = try await client.fetchProducts()
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
