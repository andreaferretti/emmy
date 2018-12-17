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

suite "test polynomials implementation":
  let
    p = poly(2, 3, 5)
    q = poly(1, -3, 6, 8)
    z = zero(Polynomial[int])

  test "polynomial reduction":
    check(poly(0) == z)
    check(poly(0, 0, 0, 0, 0) == z)
    check(poly(3, 4, 5, 0, 0) == poly(3, 4, 5))

  test "polynomial sum":
    check(p + q == poly(3, 0, 11, 8))
    check(p + q == q + p)
    check(p + 0 == p)
    check(p + 3 == poly(5, 3, 5))
    check(q + 6 == 6 + q)

  test "polynomial difference":
    check(p - q == poly(1, 6, -1, -8))
    check(p - q == -(q - p))
    check(0 - p == -p)
    check(q - 4 == poly(-3, -3, 6, 8))

  test "polynomial product":
    check(p * 0 == poly(0))
    check(p * 1 == p)
    check(1 * q == q)
    check(p * q == poly(2, -3, 8, 19, 54, 40))

  test "polynomial operations over variables":
    var a = p
    a += q
    check(a == p + q)
    var b = p
    b -= q
    check(b == p - q)
    var c = p
    c *= q
    check(c == p * q)

  test "comparison of polynomials and constants":
    check(poly(4) == 4)
    check(6 == poly(6))
    check(0 == poly(0))

  test "trivial polynomial division":
    let
      p = poly(2.0, 3.0, 5.0)
      q = poly(1.0, -3.0, 6.0, 8.0)
    check(p div q == 0.0)
    check(p %% q == p)

  test "polynomial division":
    let
      p = poly(2.quot, 3.quot, 5.quot)
      q = poly(1.quot, -3.quot, 6.quot, 8.quot)
    check(q div p == poly(6 /// 25, 8 /// 5))
    check(q %% p == poly(13 /// 25, -173 /// 25))

  # TODO: the following cannot work unless modular elements
  # encode the modulo in their type as a `static[A]`. Modular
  # elements with variable modulo do not form a ring, hence
  # polynomial operations on them do not work.
  #
  # test "polynomials with modular coefficients":
  #   let
  #     p = poly(2.modulo(5), 3.modulo(5), 4.modulo(5))
  #     q = poly(1.modulo(5), 2.modulo(5), 1.modulo(5))
  #   check(p + q == 3.modulo(5))

  test "polynomials over a field are an Euclidean ring":
    let a = poly(1.0, 3.0, -2.5)
    check(a is EuclideanRing)

  test "polynomials over a ring are a ring":
    let b = poly(1, 3, -2)
    check(b is Ring)


suite "test polynomials DSL":
  test "polynomial sum":
    const X = poly(1)
    let
      p = 2 + 3 * X + 5 * X * X
      q = 1 - 3 * X + 6 * X * X + 8 * X * X * X
      r = 3 + 11 * X * X + 8 * X * X * X

    check(p + q == r)