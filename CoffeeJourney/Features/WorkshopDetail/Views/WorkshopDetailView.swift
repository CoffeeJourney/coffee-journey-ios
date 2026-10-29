//
//  WorkshopDetailView.swift
//  CoffeeJourney
//
//  Created by morealcode on 27/10/2026.
//

import SwiftUI

struct WorkshopDetailView: View {
    let workshopID: UUID
    @State var viewModel: WorkshopDetailViewModel
    @State private var showCancelConfirmation = false

    var body: some View {
        ZStack {
            if let workshop = viewModel.workshop {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Image(WorkshopsViewModel.imageForCategory(workshop.categoryName))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .clipShape(.rect(cornerRadius: 14))
                        Text(workshop.name)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(.primaryBrown)
                        
                        HStack(spacing: 12) {
                            Image(systemName: WorkshopsViewModel.iconForCategory(workshop.categoryName))
                                .font(.system(size: 18))
                                .foregroundStyle(.primaryBrown)
                                .frame(width: 44, height: 44)
                                .background(WorkshopsViewModel.colorForCategory(workshop.categoryName))
                                .clipShape(.rect(cornerRadius: 12))

                            Text(workshop.categoryName)
                                .font(.system(size: 13))
                                .foregroundStyle(.primaryBrown)
                        }
                        
                        Divider()
                            .overlay(.secondaryBrown.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .frame(width: 20)
                                    .foregroundStyle(.secondaryBrown)

                                Text(workshop.formattedDate)
                                    .foregroundStyle(.primaryBrown)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person.2")
                                    .frame(width: 20)
                                    .foregroundStyle(.secondaryBrown)

                                Text("\(workshop.availablePlaces) spots left")
                                    .foregroundStyle(.primaryBrown)
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "clock")
                                    .frame(width: 20)
                                    .foregroundStyle(.secondaryBrown)

                                Text(workshop.formattedTime)
                                    .foregroundStyle(.primaryBrown)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "mappin.and.ellipse")
                                    .frame(width: 20)
                                    .foregroundStyle(.secondaryBrown)

                                Text("Tasting Room")
                                    .foregroundStyle(.primaryBrown)
                            }
                        }
                        
                        Divider()
                            .overlay(.secondaryBrown.opacity(0.3))

                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ABOUT THIS WORKSHOP")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondaryBrown)

                            Text(workshop.description)
                                .font(.system(size: 14))
                                .foregroundStyle(.primaryBrown)
                        }
                        
                        if viewModel.hasAlreadyReserved {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.primaryGreen)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your reservation is confirmed!")
                                        .font(.system(size: 14, weight: .semibold))

                                    Text("You will receive a reminder before the workshop.")
                                        .font(.system(size: 12))
                                }
                                .foregroundStyle(.primaryGreen)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.secondaryGreen)
                            .clipShape(.rect(cornerRadius: 12))
                        }

                        Button {
                            if viewModel.hasAlreadyReserved {
                                showCancelConfirmation = true
                            } else {
                                Task {
                                    await viewModel.reserve()
                                }
                            }
                        } label: {
                            if viewModel.isBooking {
                                ProgressView()
                            } else {
                                Text(
                                    viewModel.hasAlreadyReserved ? "Manage reservation" :
                                    !workshop.hasAvailablePlaces ? "Full booked" : "Book now"
                                )
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    !workshop.hasAvailablePlaces && !viewModel.hasAlreadyReserved
                                    ? Color.secondaryBrown
                                    : Color.primaryGreen
                                )
                                .clipShape(.rect(cornerRadius: 14))
                            }
                        }
                        .disabled(viewModel.isLoading || viewModel.isBooking || (!viewModel.hasAlreadyReserved && !viewModel.canReserve))
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                }
                .background(Color.primaryBackground.ignoresSafeArea())
            } else if viewModel.isLoading {
                ProgressView("Loading workshop…")
            } else {
                ContentUnavailableView(
                    "Workshop unavailable",
                    systemImage: "cup.and.saucer",
                    description: Text(
                        viewModel.errorMessage ?? "No information available."
                    )
                )
            }
            if showCancelConfirmation {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "trash")
                        .font(.system(size: 50))
                        .foregroundStyle(.red)

                    Text("Do you really want to cancel your reservation?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.primaryBrown)
                        .multilineTextAlignment(.center)

                    Button("Yes, cancel it") {
                        Task {
                            await viewModel.cancelReservation()

                            if !viewModel.hasAlreadyReserved {
                                showCancelConfirmation = false
                            }
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .clipShape(.rect(cornerRadius: 12))

                    Button("No, stay enrolled") {
                        showCancelConfirmation = false
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primaryGreen)
                    .clipShape(.rect(cornerRadius: 12))
                }
                .padding(24)
                .frame(maxWidth: 320)
                .background(.secondaryBackground)
                .clipShape(.rect(cornerRadius: 20))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load(workshopID: workshopID)
        }
    }
}

#Preview {
    let sessionManager = SessionManager(
        previewToken: "preview-token"
    )

    let container = AppContainer(
        sessionManager: sessionManager
    )

    let viewModel = WorkshopDetailViewModel(
        workshopService: container.workshopService,
        reservationService: container.reservationService,
        profileService: container.profileService,
        sessionManager: container.sessionManager
    )

    NavigationStack {
        WorkshopDetailView(
            workshopID: UUID(
                uuidString: "029570E7-C275-4D13-A510-F8868D931F48" // à changer selon sa base de données
            )!,
            viewModel: viewModel
        )
    }
}
