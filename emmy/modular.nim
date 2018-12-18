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

## The following type is meant to be used when the modulo is only known at
## runtime. Unfortunately, this means we can only check for mismatches
## between moduli at runtime. Moreover, we have no way of generating - given
## just the type - the zero and unit elements. Finally, the memory usage is
## doubled because each element has to hold its modulo as well.
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

# This is a version of `power` that works
# for a type `A` where one cannot deduce the identity element
# from the type `A` alone - in particular modular elements where
# the modulo is not encoded in the type. We need to find a cleaner
# solution, but this is used in `primality.test`
proc power*[A](r: Modular[A], n: int): auto =
  mixin id
  var
    n = n
    s = r
  result = id(r)
  while n > 0:
    if n mod 2 == 1:
      result = result * s
    s = s * s
    n = n div 2