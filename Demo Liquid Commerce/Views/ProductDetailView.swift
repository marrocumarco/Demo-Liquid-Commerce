//
//  ProductDetailView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 10/12/2023.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State var imagePath: String?
    @State var description: String?
    var body: some View {
        
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20){
                Text(product.name.lowercased().capitalized).font(.largeTitle)
                    .padding(.horizontal)
                    .foregroundStyle(.accent)
                if let imagePath
                {
                    AsyncImage(url: URL(fileURLWithPath: imagePath))
                    { image in image.resizable() } placeholder: { Image("image_placeholder").resizable() }.aspectRatio(contentMode: .fit)
                }
                Group{
                    Text(product.price.description + " €").font(.largeTitle)
                    Text(LocalizedStringKey("Description")).font(.title)
                        .foregroundStyle(.accent)
                    Text(description ?? "")
                }.padding(.horizontal)
            }
        }
        .onAppear()
        {
            Task{
                imagePath = try? await CachedAsyncImage(url: URL(string: product.images.first?.url ?? "") ?? URL(fileURLWithPath: "")).imagePath
            }
            description = try! NSAttributedString(data: product.description.data(using: .unicode) ?? Data(),options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
        }
    }
}

#Preview {
    ProductDetailView(product: Product(id: 1, name: "Bellu binu spuntu", description: "Su binu est bellu!\n Ma chi est totu acua...\n Tastaddu!", shortDescription: "", price: 1548.26, salePrice: 0, onSale: false, images: [ProductImage(id: 1, url: "https:/demoliquid.it/wp-content/uploads/2023/11/laguna-cannonau-demoliquid-commerce-tenuta-monte-edoardo.png", name: "binuBellu")], stockStatus: .inStock), imagePath: "", description: "")
}
