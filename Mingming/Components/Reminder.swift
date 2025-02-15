//
//  Reminder.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/14/25.
//

import SwiftUI

struct Reminder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            Spacer()
            
            VStack(alignment: .leading, spacing: .zero) {
                (Text("⏰ ")
                + Text("Drink Water"))
                    .font(.system(size: 18, weight: .medium))
                    .frame(height: 15, alignment: .center)
                    .padding(.top, 21)
                
                HStack(alignment: .bottom, spacing: .zero) {
                    Text("#HealthyLifeStyle")
                        .chip(size: .medium)
                }
                .padding(.top, 16)
                
                HStack(alignment: .center, spacing: .zero) {
                    Button {
                        
                    } label: {
                        Text("✔️ Done")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        
                    } label: {
                        Text("❌ Skipped")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        
                    } label: {
                        Text("⏳Later")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 13)
                .padding(.top, 18)

                Spacer()
            }
            .padding(.horizontal, 17)
            .frame(width: 378, height: 119, alignment: .leading)
            .background(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 6.3, x: 0, y: 0)
            .padding(.bottom, 44)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    Reminder()
}
