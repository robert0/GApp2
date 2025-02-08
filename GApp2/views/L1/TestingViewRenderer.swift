//
//  DataView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import os
import OrderedCollections


struct TestingViewRenderer: View, DataChangeListener, GestureEvaluationListener {
    @ObservedObject var viewModel = TestingViewModel()
    private static let x_scale: Double = Device.View_X_Scale
    private static let y_scale: Double = Device.View_Y_Scale

    /**
     *
     */
    var body: some View {
        VStack {
            //Text("This is TestingView rendering panel!")

            let dataProvider = viewModel.dataProvider
            if dataProvider != nil {
                //Text("Main View Update: \(viewModel.updateCounter)")

                //draw signals
                TestingSignal(viewModel)
            }

        }.border(Color.red)
    }

    
    //  TestingSignal
    //  GApp
    //
    //  Created by Robert Talianu
    //
    struct TestingSignal: View {
        @ObservedObject var viewModel: TestingViewModel

        init(_ viewModel: TestingViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            Text("Test data:").offset(x: 0, y: 0)
            let yoff = 70.0
            let tdata: RollingQueue<Sample5D>? = viewModel.dataProvider?.getTestingDataBuffer()
            if tdata != nil && tdata!.size() > 0 {
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yoff))
                        for (i, v) in tdata!.asList().enumerated() {
                            path.addLine(to: CGPoint(x: x_scale * Double(i), y: yoff + y_scale * v.x))
                        }
                    }.stroke(Color.orange)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: yoff))
                        for (i, v) in tdata!.asList().enumerated() {
                            path.addLine(to: CGPoint(x: x_scale * Double(i), y: yoff + y_scale * v.y))
                        }
                    }.stroke(Color.cyan)
                }
            }

            Text("Last detected gesture:").offset(x: 0, y: 0)

            //draw base
            let gw: GestureWindow? = viewModel.dataProvider?.getLastTestingGestureWindow()
            if gw != nil && gw!.getTimeLength() > 0 {
                let ddata: [Sample4D] = gw!.getSamples()
                if ddata.count > 0 {
                    ZStack {
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: yoff))
                            for (i, v) in ddata.enumerated() {
                                path.addLine(to: CGPoint(x: x_scale * Double(i), y: yoff + y_scale * v.x))
                            }
                        }.stroke(Color.orange)

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: yoff))
                            for (i, v) in ddata.enumerated() {
                                path.addLine(to: CGPoint(x: x_scale * Double(i), y: yoff + y_scale * v.y))
                            }
                        }.stroke(Color.cyan)
                    }.offset(x: 20, y: 0)
                }

            }

            Text("Gesture Detection Status:").offset(x: 0, y: 0)
            ForEach(viewModel.gestureEvaluationStatusMap.elements, id: \.key) { element in
                Text("\(element.key): \(element.value.getGestureCorrelationFactor())")
            }
        }
    }


    /**
     *
     */
    public func setDataProvider(_ dataProvider: RealtimeMultiGestureStoreAnalyser) {
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
        
        //maybe use async
//        DispatchQueue.main.async {
//            self.bookmarks.append(bookmark)
//        }
    }

}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class TestingViewModel: ObservableObject {
    @Published var dataProvider: RealtimeMultiGestureStoreAnalyser?
    @Published var updateCounter: Int = 1
    @Published var gestureEvaluationStatusMap = OrderedDictionary<String, GestureEvaluationStatus>()
}
