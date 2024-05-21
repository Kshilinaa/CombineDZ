//
//  TaxiView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 21.05.2024.
//
/// ЗАДАНИЕ TASK3 
import SwiftUI
import Combine

struct TaxiView: View {
    // MARK: - StateObject
    @StateObject var fakeTaxiViewModel = TaxiViewModel()
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            textFirstView
            textSecondView
            Spacer()
            HStack {
                cancelButtonView
                readyButtonView
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
    // MARK: - Visual Components
    private var textFirstView: some View {
        Text(fakeTaxiViewModel.data)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.green.opacity(0.3))
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.bottom, 10)
    }
    
    private var textSecondView: some View {
        Text(fakeTaxiViewModel.status)
            .foregroundColor(.red)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.bottom, 20)
    }
    
    private var cancelButtonView: some View {
        Button {
            fakeTaxiViewModel.cancel()
        } label: {
            Text("Отменить заказ")
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
        }
        .background(Color.red)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
    
    private var readyButtonView: some View {
        Button {
            fakeTaxiViewModel.refresh()
        } label: {
            Text("Заказать такси")
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
        }
        .background(Color.green)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

#Preview {
    TaxiView()
}
