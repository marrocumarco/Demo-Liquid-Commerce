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
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(Color.white)
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 10, content: {
                    if let imagePath {
                        AsyncImage(url: URL(fileURLWithPath: imagePath)) { image in image.resizable()
                                .aspectRatio(contentMode: .fit)
                            .frame(height: proxy.size.height * 0.666)} placeholder: {
                                Image("image_placeholder").resizable() }
                    } else {
                        Image("image_placeholder").resizable()
                    }
                    //                    Spacer()
                    Text(product.name.capitalized)
                        .lineLimit(2)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(LocalizedStringKey("Price:")).font(.caption)
                        Spacer()
                        Text("\(product.price) €").font(.subheadline.bold())
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
        // Text("Sale price: \(String(format: "%1$.2f", product.salePrice)) \(Locale.current.currencySymbol!)")
                })
                .padding(.bottom)
                .onAppear {
                    Task {
                        guard let url = URL(string: product.images.first?.url ?? "") else { return }
                        imagePath = try? await CachedAsyncThumbnail(url: url,
                                                                    size: CGSize(width: 100, height: 100),
                                                                    scale: UIScreen.main.scale).imagePath
                    }
                }
            }
        }
    }
}

#Preview {
    ProductCardView(product:
                        Product(id: 1,
                                name: "Bellu binu spuntuu",
                                description: "Su binu est bellu!\n Ma chi est totu acua...\n Tastaddu!",
                                shortDescription: "",
                                price: 1548.26,
                                salePrice: 0,
                                onSale: false,
                                images:
                                    [ProductImage(id: 1,
                                                  url: """
https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png
""",
                                                  name: "binuBellu")],
                                stockStatus: .inStock),
                    imagePath: nil)
}
