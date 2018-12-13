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

  test "checking if polynomials are irreducible":
    let p1 = poly(1.pmod(2), 1.pmod(2), 1.pmod(2))
    check(p1.isIrreducible)
    let p2 = poly(1.pmod(2), 1.pmod(2), 0.pmod(2), 1.pmod(2))
    check(p2.isIrreducible)
    let p3 = poly(1.pmod(2), 1.pmod(2), 1.pmod(2), 1.pmod(2))
    check(not p3.isIrreducible)