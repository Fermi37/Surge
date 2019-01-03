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

