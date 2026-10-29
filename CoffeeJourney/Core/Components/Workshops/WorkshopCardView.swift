//
//  WorkshopCardView.swift
//  CoffeeJourney
//
//  Created by Issa on 26/10/2026.
//

import SwiftUI

struct WorkshopCardView: View {
    
    let title: String
    let time: String
    let location: String
    let spotsLeft: Int
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    
    var category: String? = nil
    
    var body: some View {
        
        HStack(spacing: 16){
            
            // Icône principale
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundStyle(iconColor)
                .frame(width: 68, height: 68)
                .background(iconBackground)
                .clipShape(.rect(cornerRadius: 16))
            
            // Informations de l'atelier
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundStyle(.primaryBrown)
                
                Text(time)
                    .font(.system(size: 12))
                    .foregroundStyle(.primaryBrown)
                
                // Catégorie ou localisation
                HStack(spacing: 8) {
                    if let category {
                        Text(category)
                    } else {
                        Image(systemName: "mappin.and.ellipse")
                            .frame(width: 20)
                        Text(location)
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondaryBrown)
                
                // Places disponibles
                HStack(spacing: 8) {
                    Image(systemName: spotsLeft == 0 ? "xmark.circle" : "person.2")
                        .frame(width: 20)

                    Text(spotsLeft == 0 ? "Full" : "\(spotsLeft) spots left")
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondaryBrown)
            }
            
            Spacer()
            
            // Flèche
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondaryBrown)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
}
#Preview {
    WorkshopCardView(
        title: "Coffee Tasting",
        time: "10:30 – 11:30",
        location: "Main Hall",
        spotsLeft: 8,
        icon: "cup.and.saucer",
        iconColor: .primaryBrown,
        iconBackground: .secondaryBrown.opacity(0.25)
    )
    .padding(16)
    .background(.primaryBackground)
}
