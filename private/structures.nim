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

type
  AdditiveGroup* = concept x, y
    x + y is type(x)
    zero(x) is type(x)
  Ring* = concept x, y
    x is AdditiveGroup
    x * y is type(x)
    id(x) is type(x)
  EuclideanRing* = concept x, y
    x is Ring
    x div y is type(x)
    x %% y is type(x)
  Field* = concept x, y
    x is Ring
    x / y is type(x)

proc zero*(x: int): int = 0
proc zero*(x: int32): int32 = 0
proc zero*(x: int64): int64 = 0
proc zero*(x: float): float = 0

proc id*(x: int): int = 1
proc id*(x: int32): int32 = 1
proc id*(x: int64): int64 = 1
proc id*(x: float): float = 1