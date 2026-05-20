import FlatBuffers
import Foundation
import LoopAlgorithm
import LoopAlgorithmFBS

// stub for running the loop algorithm
@_expose(wasm, "run_algorithm")
public func run_algorithm(
    // Pointer to bytebuffer containing serialized AlgorithmInputFixture
    inputPtr: UnsafePointer<UInt8>,
    // The length of the byte buffer
    inputLen: Int32,
    // Pointer to the bytebuffer containing serialized AlgorithmOutput
    outputPtr: UnsafeMutablePointer<UInt8>,
    // The max length of the byte buffer (The number of bytes written is returned by the function)
    outputMaxLen: Int32
) -> Int32 {
    let bb = ByteBuffer(
        assumingMemoryBound: UnsafeMutableRawPointer(mutating: inputPtr), capacity: Int(inputLen))
    let rootOffset = bb.read(def: Int32.self, position: bb.reader) + Int32(bb.reader)
    let input = FBSLoopAlgorithmInputFixture(bb, o: rootOffset)

    let algoInput = convertInput(input)
    let output = LoopAlgorithm.run(input: algoInput)

    // let encoder = JSONEncoder()
    // encoder.dateEncodingStrategy = .iso8601
    // let outputData = try! encoder.encode(output)
    // outputData.copyBytes(to: outputPtr, count: outputData.count)
    // return Int32(outputData.count)
    return Int32(0)
}

// stub to get swift to manage allocating memory in the WASM sandbox
@_expose(wasm, "alloc")
public func alloc(size: Int32) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 8)
}

// stub to get swift to manage deallocating memory in the WASM sandbox
@_expose(wasm, "dealloc")
public func dealloc(ptr: UnsafeMutableRawPointer) {
    ptr.deallocate()
}
