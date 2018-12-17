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

import emmy, unittest, random

suite "test integers modulo N implementations":
  test "operations modulo a prime":
    let
      a = 3.pmod(7)
      b = 5.pmod(7)
    check(a + b == 1.pmod(7))
    check(a - b == 5.pmod(7))
    check(a * b == 1.pmod(7))
    check(a / b == 2.pmod(7))

  test "operations modulo a non-prime":
    let
      a = 8.pmod(12)
      b = 5.pmod(12)
    check(a + b == 1.pmod(12))
    check(a - b == 3.pmod(12))
    check(a * b == 4.pmod(12))
    when compiles(a / b):
      fail

  test "casting of integers to modulo N":
    let
      a = 8.pmod(12)
      b = 5
    check(a + b == 1.pmod(12))
    check(a - b == 3.pmod(12))
    check(a * b == 4.pmod(12))
    check(b + a == 1.pmod(12))
    check(b - a == 9.pmod(12))
    check(b * a == 4.pmod(12))

  test "checking if polynomials are irreducible":
    let
      one = id(Polynomial[Modulo[2]])
      x = X(Polynomial[Modulo[2]])
    let p1 = one + x + x^2
    check(p1.isIrreducible)
    let p2 = one + x + x^3
    check(p2.isIrreducible)
    let p3 = one + x + x^2 + x^3
    check(not p3.isIrreducible)

  test "checking if polynomials mod 3 are irreducible":
    let
      one = id(Polynomial[Modulo[3]])
      x = X(Polynomial[Modulo[3]])
    let p1 = one + x + x^2
    check(not p1.isIrreducible)
    let p2 = one + 2.pmod(3) * x + x^3
    check(p2.isIrreducible)
    let p3 = one + 2.pmod(3) * x + 2.pmod(3) * x^3
    check(not p3.isIrreducible)

  test "check that a random reducible polynomial is reducible":
    const P = 17
    let degree1 = 13
    let degree2 = 11
    var
      rng = initRand(12345)
      coefficients1 = newSeq[Modulo[P]](degree1 + 1)
      coefficients2 = newSeq[Modulo[P]](degree2 + 1)
    for i in 0 .. degree1:
      coefficients1[i] = rng.rand(P - 1).pmod(P)
    for i in 0 .. degree2:
      coefficients2[i] = rng.rand(P - 1).pmod(P)
    let
      p1 = polynomial(coefficients1)
      p2 = polynomial(coefficients2)
      p = p1 * p2

    check(not p.isIrreducible)