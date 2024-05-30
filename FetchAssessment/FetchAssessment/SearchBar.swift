//
//  SearchBar.swift
//  FetchAssessment
//
//  Created by Sparsh Ramchandani on 5/30/24.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("What's for Dessert?", text: $text)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
        )
        .padding(.horizontal)
    }
}
