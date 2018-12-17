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

type
  AdditiveMonoid* = concept x, y, type T
    x + y is T
    zero(T) is T
  AdditiveGroup* = concept x, y, type T
    T is AdditiveMonoid
    -x is T
    x - y is T
  MultiplicativeMonoid* = concept x, y, type T
    x * y is T
    id(T) is T
  MultiplicativeGroup* = concept x, y, type T
    T is MultiplicativeMonoid
    x / y is T
  Ring* = concept type T
    T is AdditiveGroup
    T is MultiplicativeMonoid
  EuclideanRing* = concept x, y, type T
    T is Ring
    x div y is T
    x mod y is T
  Field* = concept type T
    T is Ring
    T is MultiplicativeGroup

proc zero*(x: typedesc[int]): int = 0
proc zero*(x: typedesc[int32]): int32 = 0
proc zero*(x: typedesc[int64]): int64 = 0
proc zero*(x: typedesc[float32]): float32 = 0
proc zero*(x: typedesc[float64]): float64 = 0

proc id*(x: typedesc[int]): int = 1
proc id*(x: typedesc[int32]): int32 = 1
proc id*(x: typedesc[int64]): int64 = 1
proc id*(x: typedesc[float32]): float32 = 1
proc id*(x: typedesc[float64]): float64 = 1