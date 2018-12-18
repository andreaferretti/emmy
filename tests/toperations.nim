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

suite "test algebraic operations":
  test "powers produce the correct results":
    check(2 ^ 1 == 2)
    check(2 ^ 2 == 4)
    check(2 ^ 10 == 1024)
    check(3 ^ 17 == 129140163)
    check(5 ^ 15 == 30517578125)

  test "gcd gives the correct results":
    check(gcd(2, 5) == 1)
    check(gcd(24, 12) == 12)
    check(gcd(24, 16) == 8)
    check(gcd(220082744, 16126636) == 4516)

  test "lcm gives the correct results":
    check(lcm(2, 5) == 10)
    check(lcm(24, 12) == 24)
    check(lcm(24, 16) == 48)
    check(lcm(220082744, 16126636) == 785915478824)

  test "we can write the gcd as a linear combination":
    check(gcdCoefficients(23, 17) == (3, -4))
    check(gcdCoefficients(2, 5) == (-2, 1))
    check(gcdCoefficients(24, 12) == (0, 1))
    check(gcdCoefficients(24, 16) == (1, -1))

  test "the results of gcd and extended gcd agree":
    var rng = initRand(12345)
    for _ in 0 .. 100:
      let
        a = rng.rand(100000)
        b = rng.rand(100000)
      check(gcd(a, b) == extendedGcd(a, b).gcd)