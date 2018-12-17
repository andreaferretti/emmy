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

suite "pair types implement appropriate typeclasses":
  test "pairs of integers are a ring":
    check((1, 2) is Ring)
    check((1, 2) + (3, 4) == (4, 6))
    check((1, 2) - (3, 4) == (-2, -2))
    check(-(3, 4) == (-3, -4))
    check((1, 2) * (3, 4) == (3, 8))
    check(zero((int, int)) == (0, 0))
  test "pairs of an int and a float are a ring":
    check((1, 2.0) is Ring)
    check((1, 2.0) + (3, 4.0) == (4, 6.0))
    check((1, 2.0) - (3, 4.0) == (-2, -2.0))
    check(-(3, 4.0) == (-3, -4.0))
    check((1, 2.0) * (3, 4.0) == (3, 8.0))
    check(zero((int, float64)) == (0, 0.0))