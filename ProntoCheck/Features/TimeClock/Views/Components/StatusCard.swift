//
//  StatusCard.swift
//  ProntoCheck
//
//  Created by luisr on 12/07/26.
//
import SwiftUI

struct StatusCard: View {
    
    let title: String
    let value: String
    let systemImage: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(
                    isValid ? Color.green : Color.gray
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.headline)
                    .foregroundStyle(
                        isValid ? Color.green : Color.gray
                    )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 5,
            y: 2
        )
    }
}
