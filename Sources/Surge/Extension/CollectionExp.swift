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
