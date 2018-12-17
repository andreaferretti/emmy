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

type Fraction*[A] = object
  a, b: A

proc denom*[A](x: Fraction[A]): A = x.a

proc numer*[A](x: Fraction[A]): A = x.b

proc `$`*[A](x: Fraction[A]): string = $(x.a) & " / " & $(x.b)

proc `+`*[A](x, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: x.a * y.b + x.b * y.a, b: x.b * y.b)

proc `+`*[A](x: Fraction[A], y: A): Fraction[A] =
  Fraction[A](a: x.a + x.b * y, b: x.b)

proc `+`*[A](x: A, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: y.a + y.b * x, b: y.b)

template `+=`*[A](a: var Fraction[A], b: Fraction[A]) =
  let c = a
  a = c + b

proc `-`*[A](x: Fraction[A]): Fraction[A] =
  Fraction[A](a: -x.a, b: x.b)

proc `-`*[A](x, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: x.a * y.b - x.b * y.a, b: x.b * y.b)

proc `-`*[A](x: Fraction[A], y: A): Fraction[A] =
  Fraction[A](a: x.a - x.b * y, b: x.b)

proc `-`*[A](x: A, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: y.b * x - y.a, b: y.b)

template `-=`*[A](a: var Fraction[A], b: Fraction[A]) =
  let c = a
  a = c - b

proc `*`*[A](x, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: x.a * y.a, b: x.b * y.b)

proc `*`*[A](x: Fraction[A], y: A): Fraction[A] =
  Fraction[A](a: x.a * y, b: x.b)

proc `*`*[A](x: A, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: x * y.a, b: y.b)

proc `/`*[A](x, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: x.a * y.b, b: x.b * y.a)

proc `/`*[A](x: Fraction[A], y: A): Fraction[A] =
  Fraction[A](a: x.a, b: x.b * y)

proc `/`*[A](x: A, y: Fraction[A]): Fraction[A] =
  Fraction[A](a: y.b * x, b: y.a)

proc `==`*[A](x, y: Fraction[A]): bool = x.a * y.b == x.b * y.a

proc `==`*[A](x: Fraction[A], y: A): bool = x.a == x.b * y

proc `==`*[A](x: A, y: Fraction[A]): bool = y.a == y.b * x

proc zero*[A](x: typedesc[Fraction[A]]): Fraction[A] =
  Fraction[A](a: zero(A), b: id(A))

proc id*[A](x: typedesc[Fraction[A]]): Fraction[A] =
  Fraction[A](a: id(A), b: id(A))

proc quot*[A](x: A): Fraction[A] =
  Fraction[A](a: x, b: id(A))

proc `///`*[A](a: A, b: A): Fraction[A] = Fraction[A](a: a, b: b)