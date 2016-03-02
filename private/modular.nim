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

type Modular*[A] = object
  a, m: A

proc `$`*[A: EuclideanRing](x: Modular[A]): string =
  result = ""
  result.add($(x.a))
  result.add(" mod ")
  result.add($(x.m))

proc modulo*[A: EuclideanRing](a, m: A): Modular[A] = Modular[A](a: a mod m, m: m)

proc lift*[A: EuclideanRing](x: Modular[A]): A = x.a

proc `+`*[A: EuclideanRing](x, y: Modular[A]): Modular[A] =
  assert x.m == y.m
  (x.a + y.a).modulo(x.m)

proc `+`*[A: EuclideanRing](x: Modular[A], y: A): Modular[A] =
  (x.a + y).modulo(x.m)

proc `-`*[A: EuclideanRing](x, y: Modular[A]): Modular[A] =
  assert x.m == y.m
  (x.a - y.a).modulo(x.m)

proc `-`*[A: EuclideanRing](x: Modular[A], y: A): Modular[A] =
  (x.a - y).modulo(x.m)

proc `-`*[A: EuclideanRing](x: Modular[A]): Modular[A] =
  Modular[A](a: x.m - x.a, m: x.m)

proc `*`*[A](x, y: Modular[A]): Modular[A] =
  assert x.m == y.m
  (x.a * y.a).modulo(x.m)

proc `*`*[A: EuclideanRing](x: Modular[A], y: A): Modular[A] =
  (x.a * y).modulo(x.m)

proc `==`*[A: EuclideanRing](x, y: Modular[A]): bool =
  (x.m == y.m) and (((x.a - y.a) mod x.m) == 0)

proc id*[A](x: Modular[A]): Modular[A] =
  id(A).modulo(x.m)

proc zero*[A: EuclideanRing](x: Modular[A]): Modular[A] =
  zero(A).modulo(x.m)