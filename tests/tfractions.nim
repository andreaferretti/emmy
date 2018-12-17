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

suite "test fraction fields":
  test "fraction operations":
    let
      a = 2 /// 3
      b = 5 /// 7
    check(a + b == 29 /// 21)
    check(a - b == -1 /// 21)
    check(a * b == 10 /// 21)
    check(a / b == 14 /// 15)

  test "fraction comparison":
    check(2 /// 3 == 10 /// 15)
    check(3 /// 4 == 15 /// 20)
    check(1 /// 2 == -2 /// -4)

  test "operations with fractions and constants":
    let a = 2 /// 3
    check(a * 3 == 2)
    check(a * 5 == 10 /// 3)
    check(4 * a == 8 /// 3)
    check(1 - a == a / 2)

  test "comparison of fractions and constants":
    check(15 /// 3 == 5)
    check(-2 == -8 /// 4)

  test "conversion of constants to fractions":
    check(5.quot == 5 /// 1)
    check(12.quot == 12 /// 1)