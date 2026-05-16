import Foundation
import LoopAlgorithm

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
    let inputData = Data(bytes: inputPtr, count: Int(inputLen))
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let input = try! decoder.decode(AlgorithmInputFixture.self, from: inputData)

    let output = LoopAlgorithm.run(input: input)

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let outputData = try! encoder.encode(output)
    outputData.copyBytes(to: outputPtr, count: outputData.count)
    return Int32(outputData.count)
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
