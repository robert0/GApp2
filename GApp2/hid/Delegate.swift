//
//  Delegate.swift
//  GApp2
//
//  Created by Robert Talianu
//
//import CoreHID
//
//final class Delegate : HIDVirtualDeviceDelegate {
//    // A handler for system requests to send data to the device.
//    func hidVirtualDevice(_ device: HIDVirtualDevice, receivedSetReportRequestOfType type: HIDReportType, id: HIDReportID?, data: Data) throws {
//        print("Device received a set report request for report type:\(type) id:\(String(describing: id)) with data:[\(data.map { String(format: "%02x", $0) }.joined(separator: " "))]")
//    }
//
//
//    // A handler for system requests to query data from the device.
//    func hidVirtualDevice(_ device: HIDVirtualDevice, receivedGetReportRequestOfType type: HIDReportType, id: HIDReportID?, maxSize: size_t) throws -> Data {
//        print("Device received a get report request for report type:\(type) id:\(String(describing: id))")
//        assert(maxSize >= 4)
//        return (Data([1, 2, 3, 4]))
//    }
//}
