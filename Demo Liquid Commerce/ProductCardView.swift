//
//  ProductCardView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 10/12/2023.
//

import SwiftUI

struct ProductCardView: View {
    let productsListViewModel: ProductsListViewModel
    let product: Product
    @State var imagePath: String?

    var body: some View {
        GeometryReader{proxy in
            LazyVStack(alignment: .center, content: {
                if let imagePath
                {
                    AsyncImage(url: URL(fileURLWithPath: imagePath))
                    { image in image.resizable() } placeholder: { Image("image_placeholder").resizable() }.aspectRatio(contentMode: .fit).frame(height: proxy.size.height / 2)
                }
                Text(product.name)
                Text("Price: \(String(format: "%1$.2f", product.price)) \(Locale.current.currencySymbol!)")//.strikethrough()
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
