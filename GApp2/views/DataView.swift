//
//  DataView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import os
import OrderedCollections


struct DataView: View, DataChangeListener, GestureEvaluationListener {
    @ObservedObject var viewModel = DataViewModel()
    private static let x_scale: Double = Device.View_X_Scale
    private static let y_scale: Double = Device.View_Y_Scale

    //  RecordedSignal
    //  GApp
    //
    //  Created by Robert Talianu
    //
    struct RecordedSignal: View {
        @ObservedObject var viewModel: DataViewModel

        init(_ viewModel: DataViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            Text("Update rederer: \(viewModel.updateCounter)")
            Text("Recorded data:")
            let dataKeys = viewModel.dataProvider?.getKeys()
            if dataKeys != nil && dataKeys!.count > 0 {
                VStack {
                    ForEach(0..<dataKeys!.count) { index in
                        let key = dataKeys![index]
                        let samples: [Sample4D]? = viewModel.dataProvider!.getRecordingData(key)
                        let base: BaseSignalProp4D? = viewModel.dataProvider!.getRecordingSignalBase(key)
                        if samples != nil {
                            ZStack {
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: 0))
                                    for (i, v) in samples!.enumerated() {
                                        path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.x))
                                    }
                                }.stroke(Color.blue)

                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: 0))
                                    for (i, v) in samples!.enumerated() {
                                        path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.y))
                                    }
                                }.stroke(Color.red)

                                //add base start/stop window zone
                                let start: Int = base?.getStartIndex() ?? 10
                                let end: Int = base?.getEndIndex() ?? 190
                                Path { path in
                                    path.move(to: CGPoint(x: x_scale * Double(start), y: -20))
                                    path.addLine(to: CGPoint(x: x_scale * Double(start), y: 20))
                                    path.move(to: CGPoint(x: x_scale * Double(end), y: -20))
                                    path.addLine(to: CGPoint(x: x_scale * Double(end), y: 20))
                                }.stroke(Color.green)

                            }
                        }
                    }
                }
            }
        }
    }

    //  TestingSignal
    //  GApp
    //
    //  Created by Robert Talianu
    //
    struct TestingSignal: View {
        @ObservedObject var viewModel: DataViewModel

        init(_ viewModel: DataViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            Text("Test data:").offset(x: 0, y: -10)
            let tdata: RollingQueue<Sample5D>? = viewModel.dataProvider?.getTestingDataBuffer()
            if tdata != nil && tdata!.size() > 0 {
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        for (i, v) in tdata!.asList().enumerated() {
                            path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.x))
                        }
                    }.stroke(Color.orange)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        for (i, v) in tdata!.asList().enumerated() {
                            path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.y))
                        }
                    }.stroke(Color.cyan)
                }
            }

            Text("Last detected gesture:").offset(x: 0, y: -10)

            //draw base
            let gw: GestureWindow? = viewModel.dataProvider?.getLastTestingGestureWindow()
            if gw != nil && gw!.getTimeLength() > 0 {
                let ddata: [Sample4D] = gw!.getSamples()
                if ddata.count > 0 {
                    ZStack {
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            for (i, v) in ddata.enumerated() {
                                path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.x))
                            }
                        }.stroke(Color.orange)

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            for (i, v) in ddata.enumerated() {
                                path.addLine(to: CGPoint(x: x_scale * Double(i), y: y_scale * v.y))
                            }
                        }.stroke(Color.cyan)
                    }.offset(x: 20, y: 0)
                }

            }

            Text("Gesture Detection Status:").offset(x: 0, y: -10)
            ForEach(viewModel.gestureEvaluationStatusMap.elements, id: \.key) { element in
                Text("\(element.key): \(element.value.getGestureCorrelationFactor())")
            }
        }
    }

    /**
     *
     */
    var body: some View {
        VStack {
            //Text("This is Dataview Panel!")

            let dataProvider = viewModel.dataProvider
            if dataProvider != nil {
                //Text("Main View Update: \(viewModel.updateCounter)")

                //draw signals
                RecordedSignal(viewModel)

                //draw signals
                TestingSignal(viewModel)
            }

        }.border(Color.red)

    }

    /**
     *
     */
    public func setDataProvider(_ dataProvider: RealtimeMultiGestureAnalyser) {
        self.viewModel.dataProvider = dataProvider
    }

    /**
     * triggers repaint
     */
    public func onDataChange(_ type:Int) {
        //Globals.logToScreen("DataView onDataChange...")
        self.viewModel.updateCounter += 1
    }

    /**
     *
     */
    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        Globals.logToScreen("DataView gestureEvaluationCompleted...")
        self.viewModel.gestureEvaluationStatusMap[status.getGestureKey()] = status
        //trigger repaint
        onDataChange(0)
    }

}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class DataViewModel: ObservableObject {
    @Published var dataProvider: RealtimeMultiGestureAnalyser?
    @Published var updateCounter: Int = 1
    @Published var gestureEvaluationStatusMap = OrderedDictionary<String, GestureEvaluationStatus>()
}
