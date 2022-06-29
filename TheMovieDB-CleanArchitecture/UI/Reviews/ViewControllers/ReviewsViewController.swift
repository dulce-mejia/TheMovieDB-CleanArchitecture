//
//  ReviewsViewController.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import SwiftUI
import Combine

struct ReviewsViewController: View {
    @ObservedObject var viewModel: ReviewViewModel

    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List($viewModel.reviews, id: \.id) { review in
                ReviewCellView(review: review)
            }
            .alert(isPresented: $viewModel.showNoContentMsg) {
                Alert(title: Text("Error"), message: Text("No reviews yet!"), dismissButton: .default(Text("OK")))
            }
            .navigationTitle(viewModel.title)
        }
        .padding(5)
    }
}
