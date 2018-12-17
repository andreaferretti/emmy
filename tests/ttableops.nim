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

import emmy, unittest, tables

suite "operations on tables":
  test "tables with monoid values are a monoid":
    let
      a = { "a": 1, "b": 2 }.newTable
      b = { "c": 3, "b": 5 }.newTable
      c = { "a": 1, "c": 3, "b": 7 }.newTable
    check(a + b == c)