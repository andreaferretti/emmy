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

import ./structures

proc `+`*[A: AdditiveMonoid; B: AdditiveMonoid](x, y: tuple[a: A, b: B]): tuple[a: A, b: B] =
  let
    (x1, x2) = x
    (y1, y2) = y
  return (x1 + y1, x2 + y2)

proc zero*[A: AdditiveMonoid; B: AdditiveMonoid](x: typedesc[tuple[a: A, b: B]]): tuple[a: A, b: B] =
  (zero(A), zero(B))

proc `-`*[A: AdditiveGroup; B: AdditiveGroup](x, y: tuple[a: A, b: B]): tuple[a: A, b: B] =
  let
    (x1, x2) = x
    (y1, y2) = y
  return (x1 - y1, x2 - y2)

proc `-`*[A: AdditiveGroup; B: AdditiveGroup](x: tuple[a: A, b: B]): tuple[a: A, b: B] =
  let (x1, x2) = x
  return (-x1, -x2)

proc `*`*[A: MultiplicativeMonoid; B: MultiplicativeMonoid](x, y: tuple[a: A, b: B]): tuple[a: A, b: B] =
  let
    (x1, x2) = x
    (y1, y2) = y
  return (x1 * y1, x2 * y2)

proc id*[A: MultiplicativeMonoid; B: MultiplicativeMonoid](x: typedesc[tuple[a: A, b: B]]): tuple[a: A, b: B] =
  (id(A), id(B))