//
//  Demo_Liquid_CommerceTests.swift
//  Demo Liquid CommerceTests
//
//  Created by Marco Marrocu on 17/10/2023.
//

import XCTest
@testable import Demo_Liquid_Commerce
final class StoreClientTests: XCTestCase {

    let client = BaseAuthClient()

    let customer = Customer(
        id: nil,
        username: "test",
        firstName: "",
        lastName: "",
        email: "",
        password: "test"
    )

    var existingProduct: Product!

    let semaphore = DispatchSemaphore(value: 0)
    
    override func setUpWithError() throws {
        Task {
            try? await KeyChainManager.instance.deleteCredentials()

            let productsData = try await client.fetchProducts(
                1
            )

            let products: [Product] = try StoreParser().parse(
                    productsData
            )
            existingProduct = products.filter({$0.onSale}).first!
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchProducts_success() async throws {
        // Create an expectation for an asynchronous task.
        let productsData = try await client.fetchProducts(
            1
        )
        XCTAssert(
            !productsData.isEmpty
        )
        var products = [Product]()
        XCTAssertNoThrow(
            products = try StoreParser().parse(
                productsData
            )
        )
        XCTAssertFalse(
            products.isEmpty
        )
    }
    
    func testFetchCategories_success() async throws {
        // Create an expectation for an asynchronous task.
        let categoriesData = try await client.fetchCategories()
        XCTAssert(
            !categoriesData.isEmpty
        )
        var categories = [ProductCategory]()
        XCTAssertNoThrow(
            categories = try StoreParser().parse(
                categoriesData
            )
        )
        XCTAssertFalse(
            categories.isEmpty
        )
    }
    
    func testFetchPaymentGateways_success() async throws {
        // Create an expectation for an asynchronous task.
        let paymentData = try await client.fetchPaymentGateways()
        XCTAssert(
            !paymentData.isEmpty
        )
        var paymentGateways = [PaymentGateway]()
        XCTAssertNoThrow(
            paymentGateways = try StoreParser().parse(
                paymentData
            )
        )
        XCTAssertFalse(
            paymentGateways.isEmpty
        )
    }
    
    func testFetchShippingMethods_success() async throws {
        // Create an expectation for an asynchronous task.
        let shippingData = try await client.fetchShippingMethods()
        XCTAssert(
            !shippingData.isEmpty
        )
        var shippingMethods = [ShippingMethod]()
        XCTAssertNoThrow(
            shippingMethods = try StoreParser().parse(
                shippingData
            )
        )
        XCTAssertFalse(
            shippingMethods.isEmpty
        )
    }
    
    fileprivate func genarateRandomString(
        _ characters: String,
        length: Int
    ) -> String {
        // Create an expectation for an asynchronous task.
        let chars = Array(
            characters
        )
        var string = ""
        for _ in 0 ..< length {
            let randomNumber = Int.random(
                in: Range(
                    uncheckedBounds: (
                        lower: 0,
                        upper: chars.count
                    )
                )
            )
            string.append(
                chars[randomNumber]
            )
        }
        return string
    }
    
    func testCreateNewCustomer_success() async throws {
        let username = genarateRandomString(
            "abcdefghijklmnopqrstuvwxyz",
            length: 5
        )
        let newCustomer = Customer(
            id: nil,
            username: username,
            firstName: "asdfasdf",
            lastName: "wwerwqer",
            email: "\(username)@gmail.com",
            password: "qwerty",
            billing: nil,
            shipping: nil
        )
        let data = try await client.createNewCustomer(
            newCustomer
        )
        let createdCustomer: Customer = try StoreParser().parse(
            data
        )
        XCTAssert(
            createdCustomer.username == newCustomer.username
        )
        XCTAssert(
            createdCustomer.firstName == newCustomer.firstName
        )
        XCTAssert(
            createdCustomer.lastName == newCustomer.lastName
        )
        XCTAssert(
            createdCustomer.email == newCustomer.email
        )
    }
    
    func testUpdateCustomer_success() async throws {

        var existingCustomer = customer
        existingCustomer.email = "email.modificata@gmail.com"
        let data = try await client.updateCustomer(
            existingCustomer
        )
        let modifiedCustomer: Customer = try StoreParser().parse(data)
        XCTAssert(modifiedCustomer.email == existingCustomer.email)
    }

    func testUpdateCustomerBillingAddress_success() async throws {
        let address = Address(firstName: "indirizzo", lastName: "modificato", address1: "", address2: "", city: "", state: "", postcode: "", country: "", addressType: .billing)
        let data = try await client.updateCustomerBillingAddress(customer.id!, address: address)

        let modifiedCustomer: Customer = try StoreParser().parse(data)
        XCTAssert(modifiedCustomer.billing?.firstName == "indirizzo")
        XCTAssert(modifiedCustomer.billing?.lastName == "modificato")
    }

    func testUpdateCustomerShippingAddress_success() async throws {
        let address = Address(firstName: "indirizzo", lastName: "modificato", address1: "", address2: "", city: "", state: "", postcode: "", country: "", addressType: .shipping)
        let data = try await client.updateCustomerBillingAddress(customer.id!, address: address)

        let modifiedCustomer: Customer = try StoreParser().parse(data)
        XCTAssert(modifiedCustomer.billing?.firstName == "indirizzo")
        XCTAssert(modifiedCustomer.billing?.lastName == "modificato")
    }

    func testCreateNewOrder_success() async throws {
        let shippingData = try await client.fetchShippingMethods()
        let fetchedShippingMethods: [ShippingMethod] = try StoreParser().parse(
            shippingData
        )
        let fetchedProductsData = try await client.fetchProducts(
            1
        )
        let fetchedProducts: [Product] = try StoreParser().parse(
            fetchedProductsData
        )
        let fetchedPaymentMethodsData = try await client.fetchPaymentGateways()
        let fetchedPaymentMethods: [PaymentGateway] = try StoreParser().parse(
            fetchedPaymentMethodsData
        )
        
        // Create an expectation for an asynchronous task.
        let newOrder = Order(
            id: nil,
            number: nil,
            customerId: customer.id,
            status: nil,
            paymentMethod: fetchedPaymentMethods.first?.id ?? "",
            paymentMethodTitle: fetchedPaymentMethods.first!.title,
            setPaid: true,
            billing: customer.billing!,
            shipping: customer.shipping!,
            lineItems: [LineItem(
                productId: fetchedProducts.first!.id,
                quantity: 2
            )],
            shippingLines: [ShippingLine(
                id: nil,
                methodTitle: fetchedShippingMethods.first!.title,
                methodId: fetchedShippingMethods.first!.id,
                total: "",
                totalTax: nil
            )]
        )

        let data = try await client.createOrder(
            newOrder
        )
        
        let createdOrder: Order = try StoreParser().parse(
            data
        )
        
        XCTAssert(
            createdOrder.id != nil
        )
        XCTAssert(
            createdOrder.number != nil
        )
        XCTAssert(
            createdOrder.customerId != nil
        )
        XCTAssert(
            createdOrder.status != nil
        )
        if newOrder.status != nil
        {
            XCTAssert(
                createdOrder.status == newOrder.status
            )
        }
        XCTAssert(
            createdOrder.paymentMethod == newOrder.paymentMethod
        )
        XCTAssert(
            createdOrder.paymentMethodTitle == newOrder.paymentMethodTitle
        )
        XCTAssert(
            createdOrder.billing == newOrder.billing
        )
        XCTAssert(
            createdOrder.shipping == newOrder.shipping
        )
        XCTAssert(
            createdOrder.lineItems == newOrder.lineItems
        )
        //        XCTAssert(createdOrder.shippingLines == newOrder.shippingLines)
    }

    func testFetchCartTotals_success() async throws {
        
        _ = try await client.addProductToCart(
            customer,
            product: existingProduct,
            quantity: 1
        )
        var response: CartTotals?
        response = try await client.fetchCartTotals(
            customer
        )
        XCTAssertNotNil(
            response
        )
        print(
            response as Any
        )
    }
    
    func testCalculateCartTotals_success() async throws {
        
        var response: CalculatedCart?
        response = try await client.calculateCartTotals(
            Customer(
                id: nil,
                username: "pinco pallino",
                firstName: "",
                lastName: "",
                email: "",
                password: "pinco.pallino"
            )
        )
        XCTAssertNotNil(
            response
        )
        print(
            response as Any
        )
    }
    
    func testGetCartItems_success() async throws {
        var result = CartDictionary()
        result = try await client.getCartItems(
            customer
        )
        XCTAssert(
            !result.isEmpty
        )
    }
    
    func testGetCartItemsCount_success() async throws {
        
        var result = -1
        result = try await client.getNumberOfItemsInCart(
            customer
        )
        XCTAssert(
            result >= 0
        )
    }
    
    func testClearCart_success() async throws {

        _ = try await client.clearCart(
            customer
        )
        
        let result = try await client.getNumberOfItemsInCart(
            customer
        )
        
        XCTAssert(
            result == 0
        )
    }
    
    func testAddProductToCart_success() async throws {

        _ = try await client.addProductToCart(
            customer,
            product: existingProduct,
            quantity: 3
        )
        
        _ = try await client.getCartItems(
            Customer(
                id: nil,
                username: "test",
                firstName: "",
                lastName: "",
                email: "",
                password: "test"
            )
        )
        
        let count = try await client.getNumberOfItemsInCart(
            customer
        )
        XCTAssert(
            count == 3
        )
    }
    
    func testRemoveProductFromCart_success() async throws {
        
        _ = try await client.addProductToCart(
            customer,
            product: existingProduct,
            quantity: 3
        )
        
        let cartItems = try await client.getCartItems(customer)
        
        _ = try await client.removeProductFromCart(
            customer,
            item: cartItems.values.first!
        )
    }
    
    func testUpdateProductInCart_success() async throws {
        
        _ = try await client.clearCart(
            customer
        )
        
        _ = try await client.addProductToCart(
            customer,
            product: existingProduct,
            quantity: 3
        )
        
        let cartItems = try await client.getCartItems(
            customer
        )
        
        _ = try await client.updateProductInCart(
            customer,
            item: cartItems.values.first!,
            quantity: 2
        )
        
        let count = try await client.getNumberOfItemsInCart(
            customer
        )
        
        XCTAssert(
            count == 2
        )
    }
    
    func testLogin_success() async throws {
        
        // Create an expectation for an asynchronous task.
        let data = try await client.login(
            "test",
            password: "test"
        )
        let userId: LoggedUser = try StoreParser().parse(
            data
        )
        XCTAssert(
            userId.displayName == "test"
        )
    }
    
    func testCachedAsyncImage_success() async throws
    {
        let imagePath = try await CachedAsyncImage(
            url: URL(
                string: "https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png"
            )!
        ).imagePath
        
        XCTAssert(
            FileManager.default.fileExists(
                atPath: imagePath
            )
        )
    }
    
    func test_saveCredentialsToKeyChain_success() async throws {
        try await KeyChainManager.instance.saveCredentials(Credentials(key: "zaggi", secret: "pippo123"))
    }

    func test_retrieveCredentialsFromKeyChain_success() async throws {
        let newCredentials = Credentials(key: "zaggi", secret: "pippo123")
        try await KeyChainManager.instance.saveCredentials(newCredentials)
        var credentials: Credentials?
        credentials = try await KeyChainManager.instance.retrieveCredentials()

        XCTAssertNotNil(credentials)
        XCTAssertEqual(newCredentials, credentials)
    }

    func test_updateCredentialsFromKeyChain_success() async throws {
        try await KeyChainManager.instance.updateCredentials(Credentials(key: "zaggiUpdated", secret: "pippo321"))
    }

    func test_deleteCredentialsFromKeyChain_success() async throws {
        let newCredentials = Credentials(key: "zaggi", secret: "pippo123")
        try await KeyChainManager.instance.saveCredentials(newCredentials)
        try await KeyChainManager.instance.deleteCredentials()
    }
}
