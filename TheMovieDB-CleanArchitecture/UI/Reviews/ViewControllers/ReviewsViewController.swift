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

    enum Constants {
        static let padding: CGFloat = 5
    }

    var body: some View {
        VStack {
            List($viewModel.reviews, id: \.id) { review in
                ReviewCellView(review: review)
            }
            .alert(isPresented: $viewModel.showNoContentMsg) {
                Alert(title: Text(viewModel.alertTitle),
                      message: Text(viewModel.alertMsg),
                      dismissButton: .default(Text(viewModel.alertOk)))
            }
            .navigationTitle(viewModel.title)
        }
        .onAppear(perform: {
            viewModel.loadReviews()
        })
        .padding(Constants.padding)
    }
}
