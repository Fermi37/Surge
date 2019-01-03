// Copyright © 2014-2019 the Surge contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Accelerate

extension Array where Element == Double {

     func add(_ y: [Element]) -> [Double] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = self
        let n = self.count
        cblas_daxpy(numericCast(n), 1.0, x, numericCast(1), &result, numericCast(1))
        return result
    }

    // MARK: Subtraction
    func sub(_ y: [Element]) -> [Double] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = self
        let n = self.count
        catlas_daxpby(numericCast(n), 1.0, x, numericCast(1), -1, &result, numericCast(1))
        return result
    }

    // MARK: Multiply
    public func mul<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> [Double] where X.Element == Double, Y.Element == Double {
        precondition(x.count == y.count, "Collections must have the same size")
        return withUnsafeMemory(x, y) { xm, ym in
            var results = [Double](repeating: 0.0, count: numericCast(xm.count))
            results.withUnsafeMutableBufferPointer { rbp in
                vDSP_vmulD(xm.pointer, numericCast(xm.stride), ym.pointer, numericCast(ym.stride), rbp.baseAddress!, 1, numericCast(xm.count))
            }
            return results
        }
    }

    // MARK: Divide
    /// Elemen-wise vector division.
    public func div<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> [Double] where X.Element == Double, Y.Element == Double {
        precondition(x.count == y.count, "Collections must have the same size")
        return withUnsafeMemory(x, y) { xm, ym in
            var results = [Double](repeating: 0.0, count: numericCast(xm.count))
            results.withUnsafeMutableBufferPointer { rbp in
                vDSP_vdivD(ym.pointer, numericCast(ym.stride), xm.pointer, numericCast(xm.stride), rbp.baseAddress!, 1, numericCast(xm.count))
            }
            return results
        }
    }

    // MARK: Modulo
    /// Elemen-wise modulo.
    public func mod<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> [Double] where X.Element == Double, Y.Element == Double {
        precondition(x.count == y.count, "Collections must have the same size")
        return withUnsafeMemory(x, y) { xm, ym in
            precondition(xm.stride == 1 && ym.stride == 1, "\(#function) does not support strided memory access")
            var results = [Double](repeating: 0.0, count: numericCast(xm.count))
            results.withUnsafeMutableBufferPointer { rbp in
                vvfmod(rbp.baseAddress!, xm.pointer, ym.pointer, [numericCast(xm.count)])
            }
            return results
        }
    }

    // MARK: Remainder
    /// Elemen-wise remainder.
    ///

    public func remainder<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> [Double] where X.Element == Double, Y.Element == Double {
        precondition(x.count == y.count, "Collections must have the same size")
        return withUnsafeMemory(x, y) { xm, ym in
            precondition(xm.stride == 1 && ym.stride == 1, "\(#function) does not support strided memory access")
            var results = [Double](repeating: 0.0, count: numericCast(xm.count))
            results.withUnsafeMutableBufferPointer { rbp in
                vvremainder(rbp.baseAddress!, xm.pointer, ym.pointer, [numericCast(xm.count)])
            }
            return results
        }
    }

    // MARK: Square Root

    /// Elemen-wise square root.
    ///
    /// - Warning: does not support memory stride (assumes stride is 1).
    public func sqrt<C: UnsafeMemoryAccessible>(_ x: C) -> [Float] where C.Element == Float {
        var results = [Float](repeating: 0.0, count: numericCast(x.count))
        sqrt(x, into: &results)
        return results
    }

    /// Elemen-wise square root with custom output storage.
    ///
    /// - Warning: does not support memory stride (assumes stride is 1).
    public func sqrt<MI: UnsafeMemoryAccessible, MO: UnsafeMutableMemoryAccessible>(_ x: MI, into results: inout MO) where MI.Element == Float, MO.Element == Float {
        return x.withUnsafeMemory { xm in
            results.withUnsafeMutableMemory { rm in
                precondition(xm.stride == 1 && rm.stride == 1, "sqrt doesn't support step values other than 1")
                precondition(rm.count >= xm.count, "`results` doesnt have enough capacity to store the results")
                vvsqrtf(rm.pointer, xm.pointer, [numericCast(xm.count)])
            }
        }
    }

    /// Elemen-wise square root.
    ///
    /// - Warning: does not support memory stride (assumes stride is 1).
    public func sqrt<C: UnsafeMemoryAccessible>(_ x: C) -> [Double] where C.Element == Double {
        var results = [Double](repeating: 0.0, count: numericCast(x.count))
        sqrt(x, into: &results)
        return results
    }

    /// Elemen-wise square root with custom output storage.
    ///
    /// - Warning: does not support memory stride (assumes stride is 1).
    public func sqrt<MI: UnsafeMemoryAccessible, MO: UnsafeMutableMemoryAccessible>(_ x: MI, into results: inout MO) where MI.Element == Double, MO.Element == Double {
        return x.withUnsafeMemory { xm in
            results.withUnsafeMutableMemory { rm in
                precondition(xm.stride == 1 && rm.stride == 1, "sqrt doesn't support step values other than 1")
                precondition(rm.count >= xm.count, "`results` doesnt have enough capacity to store the results")
                vvsqrt(rm.pointer, xm.pointer, [numericCast(xm.count)])
            }
        }
    }

    // MARK: Dot Product
    public func dot<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> Double where X.Element == Double, Y.Element == Double {
        return withUnsafeMemory(x, y) { xm, ym in
            precondition(xm.count == ym.count, "Vectors must have equal count")

            var result: Double = 0.0
            withUnsafeMutablePointer(to: &result) { pointer in
                vDSP_dotprD(xm.pointer, numericCast(xm.stride), ym.pointer, numericCast(ym.stride), pointer, numericCast(xm.count))
            }

            return result
        }
    }

    // MARK: - Distance
    public func dist<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> Double where X.Element == Double, Y.Element == Double {
        precondition(x.count == y.count, "Vectors must have equal count")
        let sub = x .- y
        var squared = [Double](repeating: 0.0, count: numericCast(x.count))
        squared.withUnsafeMutableBufferPointer { bufferPointer in
            vDSP_vsqD(sub, 1, bufferPointer.baseAddress!, 1, numericCast(x.count))
        }
        return sqrt(sum(squared))
    }
}
