# Copyright 2016 UniCredit S.p.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import emmy, unittest

suite "test linear algebra operations":
  test "operations over vectors":
    let
      v = @[1, 2, 3, 4, 5]
      w = @[3, 2, 5, 1, 1]
    check(v + w == @[4, 4, 8, 5, 6])
    check(v - w == @[-2, 0, -2, 3, 4])
    check(v * w == 31)

  test "in place operations over vectors":
    var v = @[1, 2, 3, 4, 5]
    let w = @[3, 2, 5, 1, 1]
    v += w
    check(v == @[4, 4, 8, 5, 6])
    v -= @[1, 2, 3, 4, 5]
    check(v == w)

  test "matrix accessors":
    let m = matrix(@[
      @[1, 2, 3, 4],
      @[2, 3, 5, 2]
    ])
    check(m[1, 2] == 5)

  test "operations over matrices":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ])
      m1 = m
      n = matrix(@[
        @[2, 1, -1, 4],
        @[0, 1, 1, 5]
      ])
      p = matrix(@[
        @[3, 3, 2, 8],
        @[2, 4, 6, 7]
      ])
    check(m + n == p)
    check(m == m1)
    check(p - n == m)
    check(p - m == n)

  test "in place operations over matrices":
    var m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ])
    let
      m1 = m
      n = matrix(@[
        @[2, 1, -1, 4],
        @[0, 1, 1, 5]
      ])
      p = matrix(@[
        @[3, 3, 2, 8],
        @[2, 4, 6, 7]
      ])
    m += n
    check(m == p)
    m -= n
    check(m == m1)