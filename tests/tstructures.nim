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

import emmy, unittest, tables, bigints

suite "known types implement appropriate typeclasses":
  test "integers are an Euclidean ring":
    check(1 is EuclideanRing)
    check(1'i32 is EuclideanRing)
    check(1'i64 is EuclideanRing)

  test "big integers are an Euclidean ring":
    check(initBigInt(1) is EuclideanRing)

  test "reals are a field":
    check(1.0 is Field)
    check(1'f32 is Field)
    check(1'f64 is Field)

  test "tables with monoid values are an additive monoid":
    let a = { "a": 1, "b": 2 }.newTable
    check(a is AdditiveMonoid)

  test "ℤ/nℤ is a ring":
    let a = 12.pmod(15)
    check(a is Ring)

  test "ℤ/pℤ, p prime, is a field":
    let a = 12.pmod(17)
    check(a is Field)

  test "rationals are a field":
    let a = 5 /// 12
    let b = initBigInt(5) /// initBigInt(12)
    check(a is Field)
    check(b is Field)