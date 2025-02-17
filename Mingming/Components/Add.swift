//
//  Add.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/9/25.
//

import SwiftUI

struct Add: View {
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            VStack(spacing: 13){
                HStack(spacing: 6){
                    TextField("Drink water", text: $viewModel.title)
                        .customize(label: "Title")
                        .frame(width: 207)
                    ZStack {
                        TextField("4:30 PM", text: $viewModel.time)
                            .customize(label: "Title")
                            .frame(width: 72)
                            .onChange(of: viewModel.selectedTime) {
                                viewModel.time = viewModel.selectedTime.formatTime()
                            }
                            .onChange(of: viewModel.showTimePicker) {
                                if viewModel.time.isEmpty {
                                    viewModel.time = Date.now.formatTime()
                                }
                            }
                        
                        Button(action: { viewModel.showTimePicker = true }) {
                            Color.clear.frame(width: 72, height: 30)
                        }
                    }
                }
                
                TagField(text: $viewModel.tags, tagsLimit: 32)
            }
            .padding(.leading, 10)
            .padding(.trailing, 14)
            .padding(.top, 21)
            .padding(.bottom, 24)
            .frame(width: 307, height: 139, alignment: .topLeading)
            .background(.white)
            .clipShape(RoundedCorners(radius: 20, corners: [.topLeft, .bottomLeft, .bottomRight]))
            .shadow(color: .black.opacity(0.25), radius: 6.3, x: 0, y: 0)
            .padding(.top, 45)
            .padding(.trailing, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .sheet(isPresented: $viewModel.showTimePicker) {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Done") {
                        viewModel.showTimePicker = false
                    }
                    .padding()
                }
                
                DatePicker("Select Time", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                
            }
            .presentationDetents([.height(300)])
        }
        .onAppear {
            viewModel.isShown = true
        }
        .onDisappear {
            viewModel.isShown = false
        }
        .opacity(viewModel.isShown ? 1: 0)
        .offset(y: viewModel.isShown ? 0 : -10)
        .animation(.easeInOut(duration: 0.5), value: viewModel.isShown)
    }
}

#Preview {
    Add(viewModel: Add.ViewModel(dataService: .shared))
}
