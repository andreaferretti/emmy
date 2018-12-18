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

# Binary ladder, unsafe against timing attacks
# We should replace it with a safe Montgomery ladder, see
# http://cr.yp.to/bib/2003/joye-ladder.pdf

proc power*[A](r: A, n: int): A =
  mixin id
  var
    n = n
    s = r
  result = id(r.type)
  while n > 0:
    if n mod 2 == 1:
      result = result * s
    s = s * s
    n = n div 2

template `^`*(r: Ring, n: int): auto = power(r, n)

type GcdResult*[R] = object
  gcd*, x*, y*: R

proc extendedGcd*[R: EuclideanRing](a, b: R): GcdResult[R] =
  let
    one = id(R)
    z = zero(R)

  var
    (x1, x2, y1, y2) = (z, one, one, z)
    a1 = a
    b1 = b
  while b1 != z:
    let
      q = a1 div b1
      r = a1 mod b1
      x = x2 - q * x1
      y = y2 - q * y1
    (a1, b1, x2, x1, y2, y1) = (b1, r, x1, x, y1, y)

  return GcdResult[R](gcd: a1, x: x2, y: y2)

proc gcd*[R: EuclideanRing](r, s: R): R =
  # extendedGcd(r, s).gcd
  # Simpler implementation to avoid the extended Euclidean algorithm
  # If cofficients are not needed
  let z = zero(R)
  var
    a = r
    b = s
  while b != z:
    let q = a mod b
    a = b
    b = q
  return a

proc lcm*[R: EuclideanRing](r, s: R): R =
  r * (s div gcd(r, s))

# Returns x, y such that
# d = xa + yb
# where d = gcd(a, b)
proc gcdCoefficients*[R: EuclideanRing](a, b: R): (R, R) =
  let g = extendedGcd(a, b)
  return (g.x, g.y)