//
//  DataView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import os
import OrderedCollections


struct CreateGestureDataRenderer: View, DataChangeListener, GestureEvaluationListener {
    @ObservedObject var viewModel = CreateGestureDataViewModel()
    private static let x_scale: Double = Device.View_X_Scale
    private static let y_scale: Double = Device.View_Y_Scale

    //  RecordedSignal
    //  GApp
    //
    //  Created by Robert Talianu
    //
    struct RecordedSignal: View {
        @ObservedObject var viewModel: CreateGestureDataViewModel

        init(_ viewModel: CreateGestureDataViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            Text("--- NEW VIEW ---")
            Text("Update rederer: \(viewModel.updateCounter)")
            Text("Recorded data:")
            
            VStack {
                let samples: [Sample4D]? = viewModel.dataProvider!.getRecordingData()
                let base: BaseSignalProp4D? = viewModel.dataProvider!.getRecordingSignalBase()
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

    /**
     *
     */
    var body: some View {
        VStack {
            //Text("This is Dataview Panel!")

            let dataProvider = viewModel.dataProvider
            if dataProvider != nil {
                Text("Main View Update: \(viewModel.updateCounter)")

                //draw signals
                RecordedSignal(viewModel)
            }

        }.border(Color.red)

    }

    /**
     *
     */
    public func setDataProvider(_ dataProvider: RealtimeMultiGestureStore) {
        self.viewModel.dataProvider = dataProvider
    }

    /**
     * triggers repaint
     */
    public func onDataChange(_ type:Int) {
        Globals.logToScreen("DataView onDataChange...")
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
final class CreateGestureDataViewModel: ObservableObject {
    @Published var dataProvider: RealtimeMultiGestureStore?
    @Published var updateCounter: Int = 1
    @Published var gestureEvaluationStatusMap = OrderedDictionary<String, GestureEvaluationStatus>()
}
