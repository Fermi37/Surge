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
    // - Warning: does not support memory stride (assumes stride is 1).

    func pow(exponents y: [Element]) -> [Element] {
        var result = [Element](repeating: 0, count: y.count)
        var x = self
        var n = Int32(self.count)
        vvpow(&result, &x, y, &n)
        return result
    }

    func pow(exponent y: Element) -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        var _y = [Element](repeating: y, count: self.count)
        vvpow(&result, &x, &_y, &n)
        return result
    }
}

extension Array where Element == Float {
    // - Warning: does not support memory stride (assumes stride is 1).

    func pow(exponents y: [Element]) -> [Element] {
        var result = [Element](repeating: 0, count: y.count)
        var x = self
        var n = Int32(self.count)
        vvpowf(&result, &x, y, &n)
        return result
    }

    func pow(exponent y: Element) -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        var _y = [Element](repeating: y, count: self.count)
        vvpowf(&result, &x, &_y, &n)
        return result
    }
}
// MARK: - Exp

extension Array where Element == Float {
/// - Warning: does not support memory stride (assumes stride is 1).

    func exp() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvexpf(&result, &x, &n)
        return result
    }

     func exp2() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvexp2f(&result, &x, &n)
        return result
    }
}


extension Array where Element == Double {
    /// - Warning: does not support memory stride (assumes stride is 1).

    func exp() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvexp(&result, &x, &n)
        return result
    }

    func exp2() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvexp2(&result, &x, &n)
        return result
    }
}

// MARK: - Log

extension Array where Element == Float {
    /// - Warning: does not support memory stride (assumes stride is 1).

    func log() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlogf(&result, &x, &n)
        return result
    }

    func log2() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlog2f(&result, &x, &n)
        return result
    }

    func log10() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlog10f(&result, &x, &n)
        return result
    }

    func logb() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlogbf(&result, &x, &n)
        return result
    }
}


extension Array where Element == Double {
    /// - Warning: does not support memory stride (assumes stride is 1).

    func log() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlog(&result, &x, &n)
        return result
    }

    func log2() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlog2(&result, &x, &n)
        return result
    }

    func log10() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlog10(&result, &x, &n)
        return result
    }

    func logb() -> [Element] {
        var result = [Element](repeating: 0, count: self.count)
        var x = self
        var n = Int32(self.count)
        vvlogb(&result, &x, &n)
        return result
    }
}

// MARK: - Statistic
extension Array where Element == Float {
    func sum() -> Element {
        var result: Element = 0.0
        let x = self
        let n = vDSP_Length(self.count)
        vDSP_sve(x, 1, &result, n)
        return result
    }
}

extension Array where Element == Double {
    func sum() -> Element {
        var result: Element = 0.0
        let x = self
        let n = vDSP_Length(self.count)
        vDSP_sveD(x, numericCast(1), &result, n)
        return result
    }

    // MARK: Sum of Absolute Values

    func asum() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        result = cblas_dasum(numericCast(n), x, numericCast(1))
        return result
    }

    // MARK: Sum of Square Values
    func sumsq() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_svesqD(x, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: Maximum
    func max() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_maxvD(x, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: Minimum
    func min() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_minvD(x, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: Mean
    func mean() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_meanvD(x, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: Mean Magnitude
    func meamg() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_meamgvD(x, numericCast(1), &result, numericCast(n))
        return result
    }


    // MARK: Mean Square Value
    func measq() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_measqvD(x, numericCast(1), &result, numericCast(n))
        return result
    }


    // MARK: Root Mean Square Value
    func rmsq() -> Element {
        var result: Element = 0.0
        let x = self
        let n = self.count
        vDSP_rmsqvD(x, numericCast(1), &result, numericCast(n))
        return result
    }

    // MARK: Standard deviation
//    func std() -> Element {
//        let diff = x - mean(x)
//        let variance = measq(diff)
//        return sqrt(variance)
//    }



    // MARK: Linear regression


    /// Performs linear regression
    ///
    /// - Parameters:
    ///   - x: Array of x-values
    ///   - y: Array of y-values
    /// - Returns: The slope and intercept of the regression line
//    public func linregress<X: UnsafeMemoryAccessible, Y: UnsafeMemoryAccessible>(_ x: X, _ y: Y) -> (slope: Double, intercept: Double) where X.Element == Double, Y.Element == Double {
//        precondition(x.count == y.count, "Vectors must have equal count")
//        let meanx = mean(x)
//        let meany = mean(y)
//        let meanxy = mean(x .* y)
//        let meanx_sqr = measq(x)
//
//        let slope = (meanx * meany - meanxy) / (meanx * meanx - meanx_sqr)
//        let intercept = meany - slope * meanx
//        return (slope, intercept)
//    }
}
