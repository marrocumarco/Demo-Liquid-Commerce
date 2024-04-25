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
    
#if DEBUG
    func testFetchProductsOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let productsData = try await client.fetchProducts(1)
        XCTAssert(!productsData.isEmpty)
        var products = [Product]()
        XCTAssertNoThrow(products = try StoreParser().parse(productsData))
        XCTAssertFalse(products.isEmpty)
    }
    
    func testFetchCategoriesOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let categoriesData = try await client.fetchCategories()
        XCTAssert(!categoriesData.isEmpty)
        var categories = [ProductCategory]()
        XCTAssertNoThrow(categories = try StoreParser().parse(categoriesData))
        XCTAssertFalse(categories.isEmpty)
    }
    
    func testFetchPaymentGatewaysOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let paymentData = try await client.fetchPaymentGateways()
        XCTAssert(!paymentData.isEmpty)
        var paymentGateways = [PaymentGateway]()
        XCTAssertNoThrow(paymentGateways = try StoreParser().parse(paymentData))
        XCTAssertFalse(paymentGateways.isEmpty)
    }
    
    func testFetchShippingMethodsOAuth1_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let shippingData = try await client.fetchShippingMethods()
        XCTAssert(!shippingData.isEmpty)
        var shippingMethods = [ShippingMethod]()
        XCTAssertNoThrow(shippingMethods = try StoreParser().parse(shippingData))
        XCTAssertFalse(shippingMethods.isEmpty)
    }
    
    func testCreateNewCustomer_success() async throws {
        let client = OAuthClient()
        // Create an expectation for an asynchronous task.
        let newCustomer = Customer(id: nil, username: "asdff", firstName: "asdfasdf", lastName: "wwerwqer", email: "werqewrq@gmail.com", password: "qwerty", billing: Address(firstName: "asdfasdf", lastName: "wwerwqer", company: "testcompany", address1: "via dotto", address2: "34", city: "nora", state: "IT", postcode: "09090", country: "OR", phone: "9498565231", email: "werqewrq@gmail.com"), shipping: Address(firstName: "asdfasdf", lastName: "wwerwqer", company: "", address1: "via dotto", address2: "34", city: "nora", state: "IT", postcode: "09090", country: "OR", phone: "9498565231", email: "werqewrq@gmail.com"))
        let data = try await client.createNewCustomer(newCustomer)
        let createdCustomer: Customer = try StoreParser().parse(data)
        XCTAssert(createdCustomer == newCustomer)
    }
    
    func testUpdateCustomer_success() async throws {
        let client = OAuthClient()

        var customerData = try await client.getCustomer(25)
        var existentCustomer: Customer = try StoreParser().parse(customerData)
        existentCustomer.email = "email.modificata@gmail.com"
        let data = try await client.updateCustomer(existentCustomer)
        let modifiedCustomer: Customer = try StoreParser().parse(data)
        XCTAssert(modifiedCustomer == existentCustomer)
    }
    
    func testCreateNewOrder_success() async throws {
        let client = OAuthClient()
        let customersData = try await client.getCustomers()
        let fetchedCustomers: [Customer] = try StoreParser().parse(customersData)
        let shippingData = try await client.fetchShippingMethods()
        let fetchedShippingMethods: [ShippingMethod] = try StoreParser().parse(shippingData)
        let fetchedProductsData = try await client.fetchProducts(1)
        let fetchedProducts: [Product] = try StoreParser().parse(fetchedProductsData)
        let fetchedPaymentMethodsData = try await client.fetchPaymentGateways()
        let fetchedPaymentMethods: [PaymentGateway] = try StoreParser().parse(fetchedPaymentMethodsData)
        
        // Create an expectation for an asynchronous task.
        let newOrder = Order(id: nil, number: nil, customerId: nil, status: nil, paymentMethod: fetchedPaymentMethods.first?.id ?? "", paymentMethodTitle: fetchedPaymentMethods.first!.title, setPaid: true, billing: fetchedCustomers.first!.billing!, shipping: fetchedCustomers.first!.shipping!, lineItems: [LineItem(id: fetchedProducts.first!.id, quantity: 2)], shippingLines: [ShippingLine(id: nil, methodTitle: fetchedShippingMethods.first!.title, methodId: fetchedShippingMethods.first!.id, total: "10.00", totalTax: nil)])
        
        
        let data = try await client.createOrder(newOrder)
        
        let createdOrder: Order = try StoreParser().parse(data)
        XCTAssert(createdOrder == newOrder)
    }
    
    
#else
    func testFetchProductsBaseAuth_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let productsData = try await client.fetchProducts(1)
        XCTAssert(!productsData.isEmpty)
        var products = [Product]()
        XCTAssertNoThrow(products = try StoreParser().parse(productsData))
        XCTAssertFalse(products.isEmpty)
    }
    
    func testFetchCategoriesBaseAuth_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let categoriesData = try await client.fetchCategories()
        XCTAssert(!categoriesData.isEmpty)
        var categories = [Category]()
        XCTAssertNoThrow(categories = try StoreParser().parse(categoriesData))
        XCTAssertFalse(categories.isEmpty)
    }
    
    func testCreateNewCustomer_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let data = try await client.createNewCustomer(Customer(id: nil, username: "asdff", firstName: "asdfasdf", lastName: "wwerwqer", email: "werqewrq@gmail.com", password: "qwerty", billing: Address(firstName: "asdfasdf", lastName: "wwerwqer", company: nil, address1: "via dotto", address2: "34", city: "nora", state: "IT", postcode: "09090", country: "OR", phone: "9498565231", email: "werqewrq@gmail.com"), shipping: Address(firstName: "asdfasdf", lastName: "wwerwqer", company: nil, address1: "via dotto", address2: "34", city: "nora", state: "IT", postcode: "09090", country: "OR", phone: "9498565231", email: "werqewrq@gmail.com")))
        let customer: Customer = try StoreParser().parse(data)
        XCTAssert(customer.username == "asdff")
    }
#endif
    
    func testLogin_success() async throws {
        let client = BaseAuthClient()
        // Create an expectation for an asynchronous task.
        let data = try await client.login("pinco pallino", password: "pinco.pallino")
        let userId: LoggedUser = try StoreParser().parse(data)
        XCTAssert(userId.name == "pinco pallino")
    }
    
    func testCachedAsyncImage_success() async throws
    {
        let imagePath = try await CachedAsyncImage(url: URL(string: "https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png")!).imagePath
        
        XCTAssert(FileManager.default.fileExists(atPath: imagePath))
    }
}
