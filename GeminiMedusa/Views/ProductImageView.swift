
import SwiftUI

struct ProductImageView: View {
    let thumbnail: String?

    var body: some View {
        if let imageUrl = thumbnail, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(10)
                .foregroundColor(.gray)
        }
    }
}
