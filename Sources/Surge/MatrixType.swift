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



protocol MatrixType: CustomStringConvertible, Sequence, Equatable {
    associatedtype Scalar: Equatable
    var rows: Int {get}
    var columns: Int {get}
    var grid: [Scalar] {get set}

    init(rows: Int, columns: Int, repeatedValue: Scalar)
    init(_ contents: [[Scalar]])
    init(row: [Scalar])
    init(column: [Scalar])
}

extension MatrixType {
    subscript(row: Int, column: Int) -> Scalar {
        get {
            assert(indexIsValidForRow(row, column: column))
            return grid[(row * columns) + column]
        }

        set {
            assert(indexIsValidForRow(row, column: column))
            grid[(row * columns) + column] = newValue
        }
    }

    private func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
}

// MARK: - Printable

extension MatrixType {
    public var description: String {
        var description = ""

        for i in 0..<rows {
            let contents = (0..<columns).map({ "\(self[i, $0])" }).joined(separator: "\t")

            switch (i, rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }

            description += "\n"
        }

        return description
    }
}

// MARK: - SequenceType

extension MatrixType {
    public func makeIterator() -> AnyIterator<ArraySlice<Scalar>> {
        let endIndex = rows * columns
        var nextRowStartIndex = 0

        return AnyIterator {
            if nextRowStartIndex == endIndex {
                return nil
            }

            let currentRowStartIndex = nextRowStartIndex
            nextRowStartIndex += self.columns

            return self.grid[currentRowStartIndex..<nextRowStartIndex]
        }
    }
}

extension MatrixType where Scalar == Double {
    //    static  func == (lhs: Self, rhs: Self) -> Bool {
    //        return lhs.rows == rhs.rows && lhs.columns == rhs.columns && lhs.grid == rhs.grid
    //    }

    func add(_ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix dimensions not compatible with addition")
        var results = y
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_daxpy(Int32(self.grid.count), 1.0, self.grid, 1, pointer.baseAddress!, 1)
        }
        return results
    }

    func sub( _ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix dimensions not compatible with subtraction")
        var results = y
        results.grid.withUnsafeMutableBufferPointer { pointer in
            catlas_daxpby(Int32(self.grid.count), 1.0, self.grid, 1, -1, pointer.baseAddress!, 1)
        }
        return results
    }

    func mul(_ alpha: Double) -> Self {
        var results = self
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_dscal(Int32(self.grid.count), alpha, pointer.baseAddress!, 1)
        }
        return results
    }

    func mul(_ y: Self) -> Self {
        precondition(self.columns == y.rows, "Matrix dimensions not compatible with multiplication")
        if self.rows == 0 || self.columns == 0 || y.columns == 0 {
            return Self(rows: self.rows, columns: y.columns, repeatedValue: 0.0)
        }
        var results = Self(rows: self.rows, columns: y.columns, repeatedValue: 0.0)
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(self.rows), Int32(y.columns), Int32(self.columns), 1.0, self.grid, Int32(self.columns), y.grid, Int32(y.columns), 0.0, pointer.baseAddress!, Int32(y.columns))
        }
        return results
    }

    func elmul(_ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix must have the same dimensions")
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid .* y.grid
        return result
    }

    func div(_ y: Self) -> Self {
        let yInv = y.inv()
        precondition(self.columns == yInv.rows, "Matrix dimensions not compatible")
        return self.mul(yInv)
    }

    func pow(_ y: Double) -> Self {
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid.pow(exponent: y)
        return result
    }


    func exp() -> Self {
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid.exp()
        return result
    }

    func sum(axies: MatrixAxies = .column) -> Self {
        switch axies {
        case .column:
            var result = Self(rows: 1, columns: self.columns, repeatedValue: 0.0)
            for i in 0..<self.columns {
                result.grid[i] = sum(self[column: i])
            }
            return result
        case .row:
            var result = Self(rows: self.rows, columns: 1, repeatedValue: 0.0)
            for i in 0..<self.rows {
                result.grid[i] = sum(self[row: i])
            }
            return result
        }
    }

    func inv() -> Self {
        precondition(self.rows == self.columns, "Matrix must be square")
        var results = self
        var ipiv = [__CLPK_integer](repeating: 0, count: self.rows * self.rows)
        var lwork = __CLPK_integer(self.columns * self.columns)
        var work = [CDouble](repeating: 0.0, count: Int(lwork))
        var error: __CLPK_integer = 0
        var nc = __CLPK_integer(self.columns)

        withUnsafeMutablePointers(&nc, &lwork, &error) { nc, lwork, error in
            withUnsafeMutableMemory(&ipiv, &work, &(results.grid)) { ipiv, work, grid in
                dgetrf_(nc, nc, grid.pointer, nc, ipiv.pointer, error)
                dgetri_(nc, grid.pointer, nc, ipiv.pointer, work.pointer, lwork, error)
            }
        }
        assert(error == 0, "Matrix not invertible")
        return results
    }

    func transpose() -> Self {
        var results = Self(rows: self.columns, columns: self.rows, repeatedValue: 0.0)
        results.grid.withUnsafeMutableBufferPointer { pointer in
            vDSP_mtransD(self.grid, 1, pointer.baseAddress!, 1, vDSP_Length(self.columns), vDSP_Length(self.rows))
        }
        return results
    }

    /// Computes the matrix determinant.
    func det() -> Double? {
        var decomposed = self
        var pivots = [__CLPK_integer](repeating: 0, count: Swift.min(self.rows, self.columns))
        var info = __CLPK_integer()
        var m = __CLPK_integer(self.rows)
        var n = __CLPK_integer(self.columns)
        _ = withUnsafeMutableMemory(&pivots, &(decomposed.grid)) { ipiv, grid in
            withUnsafeMutablePointers(&m, &n, &info) { m, n, info in
                dgetrf_(m, n, grid.pointer, m, ipiv.pointer, info)
            }
        }
        if info != 0 {
            return nil
        }
        var det = 1 as Double
        for (i, p) in zip(pivots.indices, pivots) {
            if p != i + 1 {
                det = -det * decomposed[i, i]
            } else {
                det = det * decomposed[i, i]
            }
        }
        return det
    }
}

// MARK:
extension MatrixType where Scalar == Float {
    // FIXME: use the arithmetic implementation
    func add(_ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix dimensions not compatible with addition")
        var results = y
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_saxpy(Int32(self.grid.count), 1.0, self.grid, 1, pointer.baseAddress!, 1)
        }
        return results
    }

    func sub( _ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix dimensions not compatible with subtraction")
        var results = y
        results.grid.withUnsafeMutableBufferPointer { pointer in
            catlas_saxpby(Int32(self.grid.count), 1.0, self.grid, 1, -1, pointer.baseAddress!, 1)
        }
        return results
    }

    func mul(_ alpha: Float) -> Self {
        var results = self
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_sscal(Int32(self.grid.count), alpha, pointer.baseAddress!, 1)
        }
        return results
    }

    func mul(_ y: Self) -> Self {
        precondition(self.columns == y.rows, "Matrix dimensions not compatible with multiplication")
        if self.rows == 0 || self.columns == 0 || y.columns == 0 {
            return Self(rows: self.rows, columns: y.columns, repeatedValue: 0.0)
        }
        var results = Self(rows: self.rows, columns: y.columns, repeatedValue: 0.0)
        results.grid.withUnsafeMutableBufferPointer { pointer in
            cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(self.rows), Int32(y.columns), Int32(self.columns), 1.0, self.grid, Int32(self.columns), y.grid, Int32(y.columns), 0.0, pointer.baseAddress!, Int32(y.columns))
        }
        return results
    }

    func elmul(_ y: Self) -> Self {
        precondition(self.rows == y.rows && self.columns == y.columns, "Matrix must have the same dimensions")
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid .* y.grid
        return result
    }

    func div(_ y: Self) -> Self {
        let yInv = y.inv()
        precondition(self.columns == yInv.rows, "Matrix dimensions not compatible")
        return self.mul(yInv)
    }

    func pow(_ y: Float) -> Self {
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid.pow(exponent: y)
        return result
    }


    func exp() -> Self {
        var result = Self(rows: self.rows, columns: self.columns, repeatedValue: 0.0)
        result.grid = self.grid.exp()
        return result
    }

    func sum(axies: MatrixAxies = .column) -> Self {
        switch axies {
        case .column:
            var result = Self(rows: 1, columns: self.columns, repeatedValue: 0.0)
            for i in 0..<self.columns {
                result.grid[i] = sum(self[column: i])
            }
            return result
        case .row:
            var result = Self(rows: self.rows, columns: 1, repeatedValue: 0.0)
            for i in 0..<self.rows {
                result.grid[i] = sum(self[row: i])
            }
            return result
        }
    }

    func inv() -> Self {
        precondition(self.rows == self.columns, "Matrix must be square")
        var results = self
        var ipiv = [__CLPK_integer](repeating: 0, count: self.rows * self.rows)
        var lwork = __CLPK_integer(self.columns * self.columns)
        var work = [CDouble](repeating: 0.0, count: Int(lwork))
        var error: __CLPK_integer = 0
        var nc = __CLPK_integer(self.columns)

        withUnsafeMutablePointers(&nc, &lwork, &error) { nc, lwork, error in
            withUnsafeMutableMemory(&ipiv, &work, &(results.grid)) { ipiv, work, grid in
                dgetrf_(nc, nc, grid.pointer, nc, ipiv.pointer, error)
                dgetri_(nc, grid.pointer, nc, ipiv.pointer, work.pointer, lwork, error)
            }
        }
        assert(error == 0, "Matrix not invertible")
        return results
    }

    func transpose() -> Self {
        var results = Self(rows: self.columns, columns: self.rows, repeatedValue: 0.0)
        results.grid.withUnsafeMutableBufferPointer { pointer in
            vDSP_mtrans(self.grid, 1, pointer.baseAddress!, 1, vDSP_Length(self.columns), vDSP_Length(self.rows))
        }
        return results
    }

    /// Computes the matrix determinant.
    func det() -> Double? {
        var decomposed = self
        var pivots = [__CLPK_integer](repeating: 0, count: Swift.min(self.rows, self.columns))
        var info = __CLPK_integer()
        var m = __CLPK_integer(self.rows)
        var n = __CLPK_integer(self.columns)
        _ = withUnsafeMutableMemory(&pivots, &(decomposed.grid)) { ipiv, grid in
            withUnsafeMutablePointers(&m, &n, &info) { m, n, info in
                dgetrf_(m, n, grid.pointer, m, ipiv.pointer, info)
            }
        }
        if info != 0 {
            return nil
        }
        var det = 1 as Double
        for (i, p) in zip(pivots.indices, pivots) {
            if p != i + 1 {
                det = -det * decomposed[i, i]
            } else {
                det = det * decomposed[i, i]
            }
        }
        return det
    }
}


// MARK: - Operators

//public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
//    return add(lhs, rhs)
//}
//
//public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
//    return add(lhs, rhs)
//}
//
//public func - (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
//    return sub(lhs, rhs)
//}
//
//public func - (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
//    return sub(lhs, rhs)
//}
//
//public func + (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
//    return Matrix(rows: lhs.rows, columns: lhs.columns, grid: lhs.grid + rhs)
//}
//
//public func + (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
//    return Matrix(rows: lhs.rows, columns: lhs.columns, grid: lhs.grid + rhs)
//}
//
//public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
//    return mul(lhs, rhs)
//}
//
//public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
//    return mul(lhs, rhs)
//}
//
//public func * (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
//    return mul(lhs, rhs)
//}
//
//public func * (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
//    return mul(lhs, rhs)
//}
//
//public func / (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
//    return div(lhs, rhs)
//}
//
//public func / (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
//    return div(lhs, rhs)
//}
//
//public func / (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
//    var result = Matrix<Double>(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
//    result.grid = lhs.grid / rhs
//    return result
//}
//
//public func / (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
//    var result = Matrix<Float>(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
//    result.grid = lhs.grid / rhs
//    return result
//}
//
//postfix operator ′
//public postfix func ′ (value: Matrix<Float>) -> Matrix<Float> {
//    return transpose(value)
//}
//
//public postfix func ′ (value: Matrix<Double>) -> Matrix<Double> {
//    return transpose(value)
//}
