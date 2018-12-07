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

suite "test finite fields implementations":
  test "operations modulo a prime":
    let
      a = 3.Modulo7
      b = 5.Modulo7
    check(a + b == 1.Modulo7)
    check(a - b == 5.Modulo7)
    check(a * b == 1.Modulo7)
    check(a / b == 2.Modulo7)
  test "operations modulo a non-prime":
    let
      a = 8.Modulo12
      b = 5.Modulo12
    check(a + b == 1.Modulo12)
    check(a - b == 3.Modulo12)
    check(a * b == 4.Modulo12)
    when compiles(a / b):
      fail