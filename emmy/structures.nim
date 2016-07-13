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

import bigints

type
  AdditiveMonoid* = concept x, y
    x + y is type(x)
    zero(type(x)) is type(x)
  AdditiveGroup* = concept x, y
    x is AdditiveMonoid
    -x is type(x)
    x - y is type(x)
  MultiplicativeMonoid* = concept x, y
    x * y is type(x)
    id(type(x)) is type(x)
  MultiplicativeGroup* = concept x, y
    x is MultiplicativeMonoid
    x / y is type(x)
  Ring* = concept x
    x is AdditiveGroup
    x is MultiplicativeMonoid
  EuclideanRing* = concept x, y
    x is Ring
    x div y is type(x)
    x mod y is type(x)
  Field* = concept x
    x is Ring
    x is MultiplicativeGroup

proc zero*(x: typedesc[int]): int = 0
proc zero*(x: typedesc[int32]): int32 = 0
proc zero*(x: typedesc[int64]): int64 = 0
proc zero*(x: typedesc[BigInt]): BigInt = initBigInt(0)
# proc zero*(x: float): float = 0
proc zero*(x: typedesc[float32]): float32 = 0
proc zero*(x: typedesc[float64]): float64 = 0

proc id*(x: typedesc[int]): int = 1
proc id*(x: typedesc[int32]): int32 = 1
proc id*(x: typedesc[int64]): int64 = 1
proc id*(x: typedesc[BigInt]): BigInt = initBigInt(1)
# proc id*(x: float): float = 1
proc id*(x: typedesc[float32]): float32 = 1
proc id*(x: typedesc[float64]): float64 = 1