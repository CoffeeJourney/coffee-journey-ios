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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.primaryBrown)

                Spacer()

            }

            Text(subtitle)
                .font(.system(size: 16))
                .foregroundStyle(.secondaryBrown)
        }
    }
}
