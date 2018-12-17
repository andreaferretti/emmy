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

import macros
import ./primality, ./integers_modulo

template makeFiniteField(N: int): untyped =
  when isPrimePower(N):
    const
      P = findPrimePower(N).p
      k = findPrimePower(N).k

    type
      Base = Modulo[P]
      PBase = Polynomial[Base]
      FF = distinct Polynomial[Base]

    let p = generateIrreduciblePolynomial(P, k)

    proc `+`(a, b: FF): FF =
      FF((PBase(a) + PBase(b)) mod p)

    proc `-`(a, b: FF): FF =
      FF((PBase(a) + PBase(b)) mod p)

    proc `*`(a, b: FF): FF =
      FF((PBase(a) * PBase(b)) mod p)

    proc inverse(a: FF): FF =
      let (x, _) = gcdCoefficients(PBase(a), p)
      return FF(x)

    proc `/`(a, b: FF): FF = a * inverse(b)

    proc `==`(a, b: FF): bool =
      (PBase(a) mod p) == (PBase(b) mod p)

    let alpha = FF(poly(Base(0), Base(1)))

    proc gen(T: typedesc[FF]): FF = alpha
    proc zero(T: typedesc[FF]): FF = FF(poly())
    proc id(T: typedesc[FF]): FF = FF(poly(Base(1)))

    proc `$`(a: FF): string =
      let f = PBase(a)
      let z = zero(Base)
      let one = id(Base)
      var firstTerm = true
      for i, c in f.coefficients:
        if c != z:
          if not firstTerm:
            result &= " + "
          firstTerm = false
          if i == 0 or c != one:
            result &= pp(c)
          if i == 1:
            result &= "α"
          elif i == 2:
            result &= "α²"
          elif i == 3:
            result &= "α³"
          elif i > 1:
            result &= "α^" & $(i)
      result &= " where α is a root of " & $(p) & " in ℤ/" & $(P) & "ℤ"

  else:
    {.error: $(N) & " is not a prime power".}

macro finiteField*(n: static int, typeName: untyped): untyped =
  result = newStmtList(getAst(makeFiniteField(n)))
  let typeSymbol = result[0][0][1][1][2][0]
  let exported = quote do:
    type `typeName` = `typeSymbol`
  result.add(exported)
  when defined(emmyDebug):
    echo result.toStrLit