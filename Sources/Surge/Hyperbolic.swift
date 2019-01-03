//// Copyright © 2014-2018 the Surge contributors
////
//// Permission is hereby granted, free of charge, to any person obtaining a copy
//// of this software and associated documentation files (the "Software"), to deal
//// in the Software without restriction, including without limitation the rights
//// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//// copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
////
//// The above copyright notice and this permission notice shall be included in
//// all copies or substantial portions of the Software.
////
//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//// THE SOFTWARE.
//
//import Accelerate
//
//// MARK: Hyperbolic Sine
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func sinh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvsinhf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func sinh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvsinh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
//// MARK: Hyperbolic Cosine
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func cosh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvcoshf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func cosh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvcosh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
//// MARK: Hyperbolic Tangent
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func tanh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvtanhf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func tanh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvtanh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
//// MARK: Inverse Hyperbolic Sine
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func asinh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvasinhf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func asinh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvasinh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
//// MARK: Inverse Hyperbolic Cosine
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func acosh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvacoshf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func acosh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvacosh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
//// MARK: Inverse Hyperbolic Tangent
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func atanh<X: UnsafeMemoryAccessible>(_ x: X) -> [Float] where X.Iterator.Element == Float {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Float](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvatanhf(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
//
///// - Warning: does not support memory stride (assumes stride is 1).
//public func atanh<X: UnsafeMemoryAccessible>(_ x: X) -> [Double] where X.Iterator.Element == Double {
//    return x.withUnsafeMemory { xm in
//        precondition(xm.stride == 1, "\(#function) does not support strided memory access")
//        var results = [Double](repeating: 0.0, count: numericCast(x.count))
//        results.withUnsafeMutableBufferPointer { rbp in
//            vvatanh(rbp.baseAddress!, xm.pointer, [numericCast(xm.count)])
//        }
//        return results
//    }
//}
