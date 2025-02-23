//
//  DataView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import os
import OrderedCollections


struct CreateGestureDataRenderer: View, DataChangeListener {
    
    @ObservedObject var viewModel = CreateGestureDataViewModel()
    private static let x_scale: Double = Device.View_X_Scale
    private static let y_scale: Double = Device.View_Y_Scale
    @State private var animationsRunning = true
    
    /**
     *
     */
    var body: some View {
        VStack {
            let x_scale = CreateGestureDataRenderer.x_scale,
                y_scale = CreateGestureDataRenderer.y_scale
            let dataProvider = viewModel.dataProvider
            if dataProvider != nil {
                //Text("Main View Update: \(viewModel.updateCounter)")
                HStack {
                    Text("Recording: \(viewModel.isRecording)")
                    Image(systemName:  "circlebadge" )
                         .foregroundColor(viewModel.isRecording ? .red: .green)
                         .symbolEffect(.pulse, options: .repeating, isActive: viewModel.isRecording)
                         //.contentTransition(.symbolEffect(.replace))

                    
//                    Image(systemName: "circlebadge")
//                        //.foregroundColor(animationsRunning ? .red: .green)
//                        .symbolEffect(.variableColor.iterative, value: animationsRunning)
//                    
                    //
                    //ImagePulsate()
                }
                Text("Gesture data:")
                            
                VStack {
                    let gYOffset = 100.0;
                    let samples: [Sample4D]? = viewModel.getRecordingData()
                    let base: BaseSignalProp4D? = viewModel.dataProvider!.getRecordingSignalBase()
                    if samples != nil {
                        ZStack {
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: gYOffset))
                                for (i, v) in samples!.enumerated() {
                                    path.addLine(to: CGPoint(x: x_scale * Double(i), y: gYOffset + y_scale * v.x))
                                }
                            }.stroke(Color.blue)

                            Path { path in
                                path.move(to: CGPoint(x: 0, y: gYOffset))
                                for (i, v) in samples!.enumerated() {
                                    path.addLine(to: CGPoint(x: x_scale * Double(i), y: gYOffset + y_scale * v.y))
                                }
                            }.stroke(Color.red)

                            //add base start/stop window zone
                            let start: Int = base?.getStartIndex() ?? 10
                            let end: Int = base?.getEndIndex() ?? 190
                            Path { path in
                                path.move(to: CGPoint(x: x_scale * Double(start), y: gYOffset - 20))
                                path.addLine(to: CGPoint(x: x_scale * Double(start), y: gYOffset + 20))
                                path.move(to: CGPoint(x: x_scale * Double(end), y: gYOffset - 20))
                                path.addLine(to: CGPoint(x: x_scale * Double(end), y: gYOffset + 20))
                            }.stroke(Color.green)

                        }
                    }
                    
                }
                
                Text("Mean gestures data:")
                VStack {
                    let gYOffset = 100.0;
                    let samples: [Sample4D]? = viewModel.dataProvider!.getRecordingDataMean()
                    let base: BaseSignalProp4D? = viewModel.dataProvider!.getRecordingSignalMeanBase()
                    if samples != nil {
                        ZStack {
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: gYOffset))
                                for (i, v) in samples!.enumerated() {
                                    path.addLine(to: CGPoint(x: x_scale * Double(i), y: gYOffset + y_scale * v.x))
                                }
                            }.stroke(Color.blue)

                            Path { path in
                                path.move(to: CGPoint(x: 0, y: gYOffset))
                                for (i, v) in samples!.enumerated() {
                                    path.addLine(to: CGPoint(x: x_scale * Double(i), y: gYOffset + y_scale * v.y))
                                }
                            }.stroke(Color.red)

                            //add base start/stop window zone
                            let start: Int = base?.getStartIndex() ?? 10
                            let end: Int = base?.getEndIndex() ?? 190
                            Path { path in
                                path.move(to: CGPoint(x: x_scale * Double(start), y: gYOffset - 20))
                                path.addLine(to: CGPoint(x: x_scale * Double(start), y: gYOffset + 20))
                                path.move(to: CGPoint(x: x_scale * Double(end), y: gYOffset - 20))
                                path.addLine(to: CGPoint(x: x_scale * Double(end), y: gYOffset + 20))
                            }.stroke(Color.green)

                        }
                    }
                    
                }
           
               // Text("Repetability value: " + String(format: " %.2f", viewModel.dataProvider!.getCorrelationToMean()))
            }

        }.border(Color.gray)
    }

    /**
     *
     */
    public func setDataProvider(_ dataProvider: RealtimeSingleGestureStore) {
        self.viewModel.dataProvider = dataProvider
    }

    /**
     * triggers repaint
     */
    public func onDataChange(_ type:Int) {
        if(type == RealtimeSingleGestureStore.DATA_COMPLETE_UPDATE){
            print("CreateViewRenderer DATA_COMPLETE_UPDATE...")
            setToRecodingMode(false)
        }
        Globals.logToScreen("DataView onDataChange...")
        self.viewModel.updateCounter += 1
    }

    /**
     * triggers repaint
     */
    public func setToRecodingMode(_ isRecording:Bool) {
        self.viewModel.isRecording = isRecording
        animationsRunning = isRecording
    }
}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class CreateGestureDataViewModel: ObservableObject {
    @Published var dataProvider: RealtimeSingleGestureStore?
    @Published var updateCounter: Int = 1
    @Published var gestureEvaluationStatusMap = OrderedDictionary<String, GestureEvaluationStatus>()
    @Published var isRecording: Bool = false
    
    func getRecordingData() -> [Sample4D] {
        return dataProvider?.getRecordingData() ?? []
    }
}
