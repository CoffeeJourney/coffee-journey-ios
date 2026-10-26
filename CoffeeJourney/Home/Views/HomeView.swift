import SwiftUI

struct HomeView: View {

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                // En-tête
                HStack {

                    Text("Coffee Journey")
                        .font(AppTypography.pageTitle)
                        .foregroundStyle(.primaryBrown)

                    Spacer()

                    Image(systemName: "bell")
                        .foregroundStyle(.primaryBrown)
                }

                // Message d'accueil
                VStack(alignment: .leading, spacing: 6) {

                    Text("Hello, Peter 👋")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(.primaryBrown)

                    Text("Discover the world of coffee")
                        .foregroundStyle(.secondaryBrown)
                }
                
                // Bannière
                ZStack(alignment: .bottomLeading) {
                    
                    Image("coffeeBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                    
           
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("FROM BEAN TO CUP")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)

                        Text("Explore our workshops")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .foregroundStyle(.white)

                        Button("Discover") {
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.primaryGreen)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .padding(20)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 22))
        

                // Section Today
                HStack {

                    Text("Today")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(.primaryBrown)

                    Spacer()

                    Text("See all")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.primaryGreen)
                }

                // Carte d'atelier
                VStack(spacing: 12) {

                    WorkshopCardView(
                        title: "Coffee Tasting",
                        time: "10:30 – 11:30",
                        location: "Main Hall",
                        spotsLeft: 8,
                        icon: "cup.and.saucer",
                        iconColor: .primaryBrown,
                        iconBackground: .secondaryBrown.opacity(0.25)
                    )

                    WorkshopCardView(
                        title: "Coffee Origins",
                        time: "14:00 – 15:00",
                        location: "Origins Room",
                        spotsLeft: 15,
                        icon: "globe.europe.africa",
                        iconColor: .primaryGreen,
                        iconBackground: .secondaryGreen
                    )
                }
                
                HStack(alignment: .top, spacing: 16) {

                    // Icône
                    Image(systemName: "globe")
                        .font(.system(size: 24))
                        .foregroundStyle(.primaryGreen)

                    // Informations
                    VStack(alignment: .leading, spacing: 10) {

                        Text("Two editions, one journey")
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundStyle(.primaryGreen)

                        Text("Coffee Journey also takes place in Naples, Italy.")
                            .font(.system(size: 12))
                            .foregroundStyle(.primaryGreen)

                        Text("Discover the Italian edition →")
                            .font(.system(size: 12, weight: .semibold))
                            .underline()
                            .foregroundStyle(.primaryGreen)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.secondaryGreen)
                .clipShape(.rect(cornerRadius: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .background(.primaryBackground)
    }
}

#Preview {
    HomeView()
}
