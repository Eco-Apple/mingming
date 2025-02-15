//
//  Delete.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/10/25.
//

import SwiftUI

struct Delete: View {
    var callback: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            (Text("Are you sure you want to delete ")
                .font(.title3)
            + Text("\nRunning")
                .font(.headline)
            + Text(" ?")
                .font(.title3))
            .multilineTextAlignment(.center)
            
            HStack {
                Button {
                    callback(true)
                } label: {
                    Text("Yes")
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    callback(false)
                } label: {
                    Text("No")
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 15)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .frame(width: 340)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.25), radius: 6.3, x: 0, y: 0)
    }
}

#Preview {
    Delete(callback: { _ in })
}
