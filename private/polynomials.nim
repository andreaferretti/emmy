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

type Polynomial*[A] = object
  coefficients*: seq[A]

proc reduce[A](s: seq[A]): seq[A] =
  if s.len == 0: return s
  let z = zero(s[0])
  var L = s.len - 1
  for i in 0 .. < s.len:
    if s[L] == z: L -= 1
    else: break
  if L < 0: return @[]
  else: return s[0 .. L]

proc reduce[A](p: Polynomial[A]): Polynomial[A] =
  Polynomial[A](coefficients: reduce(p.coefficients))

proc poly*[A](a: varargs[A]): Polynomial[A] = Polynomial[A](coefficients: reduce(@a))

proc deg*[A](p: Polynomial[A]): int {.inline.} = p.coefficients.len - 1

proc top*[A](p: Polynomial[A]): A {.inline.} = p.coefficients[deg(p)]

proc `$`*[A](p: Polynomial[A]): string =
  result = ""
  for i in 0 .. deg(p):
    if i == 0: result &= $(p.coefficients[i])
    elif i == 1: result &= " + " & $(p.coefficients[i]) & "*x"
    else: result &= " + " & $(p.coefficients[i]) & "*x^"  & $(i)

proc zero*[A](x: Polynomial[A]): Polynomial[A] = poly[A]()

proc id*[A](x: Polynomial[A]): Polynomial[A] = poly[A](id[A]())

proc `==`*[A](p: Polynomial[A], q: A): bool =
  (p.deg == -1 and q == zero(q)) or (p.deg == 0 and p.coefficients[0] == q)

proc `==`*[A](p: A, q: Polynomial[A]): bool =
  (q.deg == -1 and p == zero(p)) or (q.deg == 0 and q.coefficients[0] == p)

proc sumSeq[A](s, t: seq[A]): seq[A] =
  if s.len >= t.len:
    result = newSeq[A](s.len)
    for i in 0 .. < t.len:
      result[i] = s[i] + t[i]
    for i in t.len .. < s.len:
      result[i] = s[i]
  else: return sumSeq(t, s)

proc `+`*[A](p, q: Polynomial[A]): Polynomial[A] =
  Polynomial[A](coefficients: sumSeq(p.coefficients, q.coefficients))

proc `+`*[A](p: Polynomial[A], q: A): Polynomial[A] = p + poly(q)

proc `+`*[A](p: A, q: Polynomial[A]): Polynomial[A] = poly(p) + q

proc `-`*[A](p: Polynomial[A]): Polynomial[A] =
  Polynomial[A](coefficients: p.coefficients.map(proc (a: A): A =
    -a))

proc `-`*[A](p, q: Polynomial[A]): Polynomial[A] = p + (-q)

proc `-`*[A](p: Polynomial[A], q: A): Polynomial[A] = p - poly(q)

proc `-`*[A](p: A, q: Polynomial[A]): Polynomial[A] = poly(p) - q

template `+=`*[A](a: var Polynomial[A], b: Polynomial[A]) =
  let c = a
  a = c + b

template `-=`*[A](a: var Polynomial[A], b: Polynomial[A]) =
  let c = a
  a = c - b

proc mulSeq[A](s, t: seq[A]): seq[A] =
  if s.len == 0: return @[]
  let
    z = zero(s[0])
    Ls = s.len
    Lt = t.len
  var p = newSeq[A](Ls + Lt)
  for i in 0 .. < Ls + Lt - 1:
    p[i] = z
    for j in max(0, i + 1 - Lt) .. min(i, Ls - 1):
      p[i] += s[j] * t[i - j]
  return reduce(p)

proc `*`*[A](p, q: Polynomial[A]): Polynomial[A] =
  Polynomial[A](coefficients: mulSeq(p.coefficients, q.coefficients))

proc `*`*[A](p: Polynomial[A], q: A): Polynomial[A] = p * poly(q)

proc `*`*[A](p: A, q: Polynomial[A]): Polynomial[A] = poly(p) * q

template `*=`*[A](a: var Polynomial[A], b: Polynomial[A]) =
  let c = a
  a = c * b

proc monomial[A](n: int, a: A): Polynomial[A] =
  var c = newSeq[A](n + 1)
  for i in 0 .. < n:
    c[i] = zero(a)
  c[n] = a
  Polynomial[A](coefficients: c)

proc division*[A](s, t: Polynomial[A]): tuple[q: Polynomial[A], r: Polynomial[A]] =
  if deg(t) > deg(s): (poly[A](), s)
  else:
    let
      a = top(s)
      b = top(t)
      q_0 = monomial(deg(s) - deg(t), a / b)
      r_0 = reduce(s - (q_0 * t))
      (q_1, r) = division(r_0, t)
    (q_0 + q_1, r)

proc `div`*[A](s, t: Polynomial[A]): Polynomial[A] =
  let (q, r) = division(s, t)
  q

proc `%%`*[A](s, t: Polynomial[A]): Polynomial[A] =
  let (q, r) = division(s, t)
  r