//
//  GestureDataStore.swift
//  GApp
//
//  Created by Robert Talianu
//


public protocol GestureDataStoreInterface<T, S> {
    associatedtype S
    associatedtype T
    
    /**
     * @param dataChangeListener
     */
    func setChangeListener(_ dataChangeListener: DataChangeListener)

    /**
     * @param x
     * @param y
     * @param z
     */
    func addForRecording(_ x: Double, _ y: Double, _ z: Double)

    /**
     * @param x
     * @param y
     * @param z
     */
    func addForTesting(_ x: Double, _ y: Double, _ z: Double)

    /**
     * @param x
     * @param y
     * @param z
     */
    func addForRealtimeTesting(_ x: Double, _ y: Double, _ z: Double)

    /**
     *
     */
    func clearTesting()

    /**
     *
     */
    func clearRecording()

    /**
     * @return
     */
    func getRecordingData() -> S

    /**
     * @return
     */
    func getTestingData() -> S

    /**
     * @return
     */
    func getPointer() -> Int

    /**
     * @return
     */
    func getCapacity() -> Int

    /**
     * @return
     */
    func getRecordingSignalBase() -> T
}
