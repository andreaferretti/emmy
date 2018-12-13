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

import random
import ./structures, ./primality, ./operations, ./polynomials

## The following type is meant to be used when the modulo is known
## statically. It has better properties than its dynamic counterpart -
## in particular we can make it into a ring. Unfortunately, due this bug
## https://github.com/nim-lang/Nim/issues/7209
## we can only define it for a given concrete type - here `int`.
type Modulo*[N: static[int]] = distinct int

proc `$`*[N: static[int]](x: Modulo[N]): string =
  $(int(x)) & " mod " & $(N)

proc pp*[N: static[int]](x: Modulo[N]): string = $(int(x))

proc pmod*(a: int, N: static[int]): Modulo[N] = Modulo[N](a mod N)

proc `+`*[N: static[int]](a, b: Modulo[N]): Modulo[N] =
  (int(a) + int(b)).pmod(N)

proc `-`*[N: static[int]](a, b: Modulo[N]): Modulo[N] =
  (int(a) - int(b)).pmod(N)

proc `-`*[N: static[int]](a: Modulo[N]): Modulo[N] =
  (N - int(a)).pmod(N)

proc `*`*[N: static[int]](a, b: Modulo[N]): Modulo[N] =
  (int(a) * int(b)).pmod(N)

proc inv*[N: static[int]](a: Modulo[N]): Modulo[N] =
  when isPrime(N):
    if a.int mod N == 0:
      raise newException(DivByZeroError, "Division by 0")
    else:
      let (x, _) = gcdCoefficients(a.int, N)
      return x.pmod(N)
  else:
    {.error: $(N) & " is not prime".}

proc `/`*[N: static[int]](a, b: Modulo[N]): Modulo[N] =
  a * inv(b)

proc `==`*[N: static[int]](a, b: Modulo[N]): bool =
  (a.int - b.int) mod N == 0

proc zero*[N: static[int]](T: type Modulo[N]): T = 0.pmod(N)

proc id*[N: static[int]](T: type Modulo[N]): T = 1.pmod(N)

template `+=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c + b

template `-=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c - b

template `*=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c * b

template `/=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c / b

proc isIrreducible*[N: static[int]](p: Polynomial[Modulo[N]]): bool =
  when isPrime(N):
    let x = poly(Modulo[N](0), Modulo[N](1))
    var powerTerm = x

    for _ in  0 ..< (deg(p) div 2):
      powerTerm = powerTerm ^ N
      let gcdPoly = gcd(p, powerTerm - x)
      if deg(gcdPoly) > 0:
        return false

    return true
  else:
    {.error: $(N) & " is not prime".}

proc generateIrreduciblePolynomial*(P: static[int], degree: int): Polynomial[Modulo[P]] =
  var
    rng = initRand(12345)
    coefficients = newSeq[Modulo[P]](degree + 1)
  coefficients[^1] = 1.pmod(P)
  while true:
    for i in 0 ..< degree:
      coefficients[i] = rng.rand(P - 1).pmod(P)
    let randomMonicPolynomial = polynomial(coefficients)

    if isIrreducible(randomMonicPolynomial):
      return randomMonicPolynomial