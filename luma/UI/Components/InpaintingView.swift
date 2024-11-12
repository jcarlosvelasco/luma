//
//  InpaintingView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct InpaintingView: View {
    @ObservedObject var viewModel: HomeViewViewModel

    var body: some View {
        ZStack {
            ImageView(viewModel: viewModel)
                .saveSize(in: $viewModel.displayedImageSize)
            
            Canvas { context, size in
                for line in viewModel.linesPreview {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                let newPoint = value.location
                viewModel.currentLine.points.append(newPoint)
                viewModel.lines.append(viewModel.currentLine)
                viewModel.linesPreview.append(viewModel.currentLine)
            }).onEnded({ value in
                viewModel.currentLine = Line(points: [], lineWidth: viewModel.thickness)
            })
            )
            .frame(width: viewModel.displayedImageSize.width, height: viewModel.displayedImageSize.height)
        }
        
        Spacer()
        Spacer()
        
        VStack(alignment: .leading) {
            Text("Brush size")
            Slider(value: $viewModel.thickness, in: 3.0...20.0, step: 1)
            .onChange(of: viewModel.thickness) {
                viewModel.currentLine.lineWidth = viewModel.thickness
            }
        }
        .padding(.horizontal)
        
        HStack {
            Button("Apply") {
                Task {
                    await viewModel.doInpainting()
                }
            }
            .disabled(viewModel.linesPreview.isEmpty || viewModel.loading)
        }
    }
}
