//
//  ReviewView.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import SwiftUI

struct ReviewCellView: View {
    @Binding private var review: Review

    init(review: Binding<Review>) {
        self._review = review
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(review.author)
                        .foregroundColor(.blue)
                        .font(.title3)
                        .bold()
                    Text(review.authorDetails.username)
                        .italic()
                }
                Spacer()
                Text(review.authorDetails.rating == nil ? "N/A" : String(format: "%.1f", review.authorDetails.rating!))
                    .font(.title)
                    .bold()
                    .foregroundColor(.yellow)
            }
            Text(review.content ?? "")
                .font(.subheadline)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
