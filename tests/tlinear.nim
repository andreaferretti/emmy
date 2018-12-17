# Copyright 2016-18 UniCredit S.p.A.
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

{.push warning[ProveInit]: off.}

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
    var n = m
    check(m[1, 2] == 5)
    n[1, 2] = 1
    check(n[1, 2] == 1)

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

  test "matrix/vector product":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ])
      v = @[1, 3, 5, 2]
    check(m * v == @[30, 40])

  test "matrix/vector product in row major order":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ], order = rowMajor)
      v = @[1, 3, 5, 2]
    check(m * v == @[30, 40])

  test "matrix product":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ])
      n = matrix(@[
        @[1, 2, 3],
        @[1, 3, 1],
        @[2, 1, 0],
        @[1, 2, 1]
      ])
      p = matrix(@[
        @[13, 19, 9],
        @[17, 22, 11]
      ])
    check(m * n == p)

  test "matrix product in row major order":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ], order = rowMajor)
      n = matrix(@[
        @[1, 2, 3],
        @[1, 3, 1],
        @[2, 1, 0],
        @[1, 2, 1]
      ], order = rowMajor)
      p = matrix(@[
        @[13, 19, 9],
        @[17, 22, 11]
      ])
    check(m * n == p)

  test "matrix product in mixed order":
    let
      m = matrix(@[
        @[1, 2, 3, 4],
        @[2, 3, 5, 2]
      ])
      n = matrix(@[
        @[1, 2, 3],
        @[1, 3, 1],
        @[2, 1, 0],
        @[1, 2, 1]
      ], order = rowMajor)
      p = matrix(@[
        @[13, 19, 9],
        @[17, 22, 11]
      ])
    check(m * n == p)

  test "matrix transpose":
    let
      m = matrix(@[
        @[2, 1, -1, 4],
        @[0, 1, 1, 5]
      ])
      n = matrix(@[
        @[2, 0],
        @[1, 1],
        @[-1, 1],
        @[4, 5]
      ])
    check(m.t == n)
    check(n.t == m)

  test "matrix transpose sharing":
    var m = matrix(@[
      @[2, 1, -1, 4],
      @[0, 1, 1, 5]
    ])
    let
      n = matrix(@[
        @[2, 0],
        @[1, 1],
        @[-1, 1],
        @[4, 5]
      ])
      p = m.t
    check(p == n)
    m[1, 1] = -3
    check(p[1, 1] == -3)

  test "matrix to vector":
    let
      m = matrix(@[
        @[2, 1, -1, 4],
        @[0, 1, 1, 5]
      ])
      v = @[2, 0, 1, 1, -1, 1, 4, 5]
    check(m.toVector == v)

  test "matrix to vector sharing":
    var m = matrix(@[
      @[2, 1, -1, 4],
      @[0, 1, 1, 5]
    ])
    let
      v = @[2, 0, 1, 1, -1, 1, 4, 5]
      w = m.toVector
    check(w == v)
    m[0, 0] = 0
    check(w[0] == 0)

{.pop.}