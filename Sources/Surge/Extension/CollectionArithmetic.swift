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

extension Collection where Element == Double {

     func add(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vaddD(y, numericCast(1), x, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    func add(_ y: Element) -> [Element] {
        var result = Array(self)
        var _y = y
        let x = Array(self)
        let n = self.count
        vDSP_vsaddD(x, numericCast(1), &_y, &result, numericCast(1), numericCast(n))
        return result
    }


    // MARK: Subtraction
    func sub(_ y: [Element]) -> [Element] {
       precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vsubD(y, numericCast(1), x, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    func sub(_ y: Element) -> [Element] {
        var result = Array(self)
        var _y = -y
        let x = Array(self)
        let n = self.count
        vDSP_vsaddD(x, numericCast(1), &_y, &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Multiply Element - wise
    func mul(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vmulD(x, numericCast(1), y, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Divide
    /// Elemen-wise vector division.
    func div(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vdivD(x, numericCast(1), y, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Modulo
    /// Elemen-wise modulo.
    /// Calculates the modulus after dividing each element in an array by the corresponding element in a second array of double-precision values.
    ///
    /// - Parameter y: denominator
    /// - Returns: This function calculates z=y-k*x, for an integer k such that if x is nonzero, the result has the same sign as y and magnitude less than that of x.
    func mod(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        var n = Int32(self.count)
        vvfmod(&result, x, y, &n)
        return result
    }

    // MARK: Remainder
    /// Elemen-wise remainder.
    /// Calculates the remainder after dividing each element in an array by the corresponding element in a second array of double-precision values.
    ///
    /// - Parameter y: denominator
    /// - Returns:
    func remainder(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        var n = Int32(self.count)
        vvremainder(&result, x, y, &n)
        return result
    }

    // MARK: Square Root
    /// Calculates the reciprocal square root of each element in an array of double-precision values.
    ///
    /// - Returns: [Double]
    func sqrt() -> [Element] {
        var result = Array(self)
        let x = Array(self)
        var n = Int32(self.count)
        vvsqrt(&result, x, &n)
        return result
    }

     // MARK: Dot Product
    /// Computes the dot or scalar product of vectors A and B and leaves the result in scalar *C; single precision.
    ///
    /// - Parameter y: [Double]
    /// - Returns: Double
    func dot( _ y: [Element]) -> Element {
    precondition(self.count == y.count, "Collections must have the same size")
    var result: Element = 0.0
    let x = Array(self)
    let n = self.count
    vDSP_dotprD(x, numericCast(1), y, numericCast(1), &result, numericCast(n))
    return result
    }

    // MARK: - Distance
    func dist( _ y: [Element]) -> Element  {
        precondition(self.count == y.count, "Vectors must have equal count")
        let sub = self.sub(y)
        let squared = sub.dot(sub)
        return squared.squareRoot()
    }
}

extension Collection where Element == Float {

    func add(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vadd(y, numericCast(1), x, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    func add(_ y: Element) -> [Element] {
        var result = Array(self)
        var _y = y
        let x = Array(self)
        let n = self.count
        vDSP_vsadd(x, numericCast(1), &_y, &result, numericCast(1), numericCast(n))
        return result
    }


    // MARK: Subtraction
    func sub(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vsub(y, numericCast(1), x, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    func sub(_ y: Element) -> [Element] {
        var result = Array(self)
        var _y = -y
        let x = Array(self)
        let n = self.count
        vDSP_vsadd(x, numericCast(1), &_y, &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Multiply Element - wise
    func mul(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vmul(x, numericCast(1), y, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Divide
    /// Elemen-wise vector division.
    func div(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        let n = self.count
        vDSP_vdiv(x, numericCast(1), y, numericCast(1), &result, numericCast(1), numericCast(n))
        return result
    }

    // MARK: Modulo
    /// Elemen-wise modulo.
    /// Calculates the modulus after dividing each element in an array by the corresponding element in a second array of double-precision values.
    ///
    /// - Parameter y: denominator
    /// - Returns: This function calculates z=y-k*x, for an integer k such that if x is nonzero, the result has the same sign as y and magnitude less than that of x.
    func mod(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        var n = Int32(self.count)
        vvfmodf(&result, x, y, &n)
        return result
    }

    // MARK: Remainder
    /// Elemen-wise remainder.
    /// Calculates the remainder after dividing each element in an array by the corresponding element in a second array of double-precision values.
    ///
    /// - Parameter y: denominator
    /// - Returns:
    func remainder(_ y: [Element]) -> [Element] {
        precondition(self.count == y.count, "Collections must have the same size")
        var result = y
        let x = Array(self)
        var n = Int32(self.count)
        vvremainderf(&result, x, y, &n)
        return result
    }

    // MARK: Square Root
    /// Calculates the reciprocal square root of each element in an array of double-precision values.
    ///
    /// - Returns: [Double]
    func sqrt() -> [Element] {
        var result = Array(self)
        let x = Array(self)
        var n = Int32(self.count)
        vvsqrtf(&result, x, &n)
        return result
    }

    // MARK: Dot Product
    /// Computes the dot or scalar product of vectors A and B and leaves the result in scalar *C; single precision.
    ///
    /// - Parameter y: [Double]
    /// - Returns: Double
    func dot( _ y: [Element]) -> Element {
        precondition(self.count == y.count, "Collections must have the same size")
        var result: Element = 0.0
        let x = Array(self)
        let n = self.count
        vDSP_dotpr(x, numericCast(1), y, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: - Distance
    func dist( _ y: [Element]) -> Element  {
        precondition(self.count == y.count, "Vectors must have equal count")
        let sub = self.sub(y)
        let squared = sub.dot(sub)
        return squared.squareRoot()
    }
}
