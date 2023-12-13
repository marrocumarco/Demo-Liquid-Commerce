//
//  ProductCardView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 10/12/2023.
//

import SwiftUI

struct ProductCardView: View {
//    let productsListViewModel: ProductsListViewModel
    let product: Product
    @State var imagePath: String?

    var body: some View {
        GeometryReader{proxy in
            LazyVStack(alignment: .center, content: {
                if let imagePath
                {
                    AsyncImage(url: URL(fileURLWithPath: imagePath))
                    { image in image.resizable() } placeholder: { Image("image_placeholder").resizable() }
                        .scaledToFit()
                        .frame(idealHeight: proxy.size.height * 0.75)
                        //.frame(height: proxy.size.height)
                }
                
                VStack
                {
                    Text(product.name).font(.caption)
                                    Text(LocalizedStringKey("Price: \(product.price) \("€")")).font(.caption)
                }.padding(16)
                
    //            Text("Sale price: \(String(format: "%1$.2f", product.salePrice)) \(Locale.current.currencySymbol!)")
            })
                .onAppear()
            {
                Task{
                    imagePath = try! await CachedAsyncThumbnail(url: URL(string: product.images.first?.url ?? "")!, size: CGSize(width: 100, height: 100), scale: UIScreen.main.scale).imagePath
                }
            }
        }
    }
}

#Preview {
    ProductCardView(product: Product(id: 1, name: "Bellu binu spuntu", description: "Su binu est bellu!\n Ma chi est totu acua...\n Tastaddu!", shortDescription: "", price: 1548.26, salePrice: 0, onSale: false, images: [ProductImage(id: 1, url: "https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png", name: "binuBellu")], stockStatus: .inStock), imagePath: nil)
}
