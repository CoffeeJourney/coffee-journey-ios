//
//  PageHeaderView.swift
//  CoffeeJourney
//
//  Created by Issa on 28/10/2026.
//

import SwiftUI

struct PageHeaderView: View {

    let title: String
    let subtitle: String
    
    var showSearch: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.primaryBrown)

                Spacer()

                if showSearch {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                        .foregroundStyle(.primaryBrown)
                }
            }

            Text(subtitle)
                .font(.system(size: 16))
                .foregroundStyle(.secondaryBrown)
        }
    }
}
