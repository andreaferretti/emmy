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

suite "test dynamic modular operations":
  test "modular sum":
    let
      a = 3.modulo(7)
      b = 5.modulo(7)
    check(a + b == 1.modulo(7))

  test "modular difference":
    let
      a = 3.modulo(7)
      b = 5.modulo(7)
    check(a - b == 5.modulo(7))

  test "modular multiplication":
    let
      a = 3.modulo(7)
      b = 5.modulo(7)
    check(a * b == 1.modulo(7))

  test "modular sum with an integer":
    let
      a = 3.modulo(7)
      b = 5
    check(a + b == 1.modulo(7))

  test "modular difference with an integer":
    let
      a = 3.modulo(7)
      b = 5
    check(a - b == 5.modulo(7))

  test "modular multiplication with an integer":
    let
      a = 3.modulo(7)
      b = 5
    check(a * b == 1.modulo(7))