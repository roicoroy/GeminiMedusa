
//
//  SplashScreenView.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var regionService: RegionService
    @State private var isActive = false
    @State private var showingRegionSelection = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            // This view will be dismissed by the parent (GeminiMedusaApp) once isActive is true
            EmptyView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "cube.fill") // Placeholder icon
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    Text("GeminiMedusa")
                        .font(Font.largeTitle)
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        if regionService.selectedCountry == nil {
                            self.showingRegionSelection = true
                        } else {
                            self.isActive = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingRegionSelection) {
                RegionSelectionView(regionService: regionService, isPresented: $showingRegionSelection)
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
