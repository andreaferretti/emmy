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

type Polynomial*[I: static[string], A] = object
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

proc polynomial*[A](I: static[string], a: seq[A]): Polynomial[I, A] =
  Polynomial[I, A](coefficients: reduce(a))

proc polynomial*[A](I: static[string], a: varargs[A]): Polynomial[I, A] =
  Polynomial[I, A](coefficients: reduce(@a))

proc reduce[I: static[string], A](p: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, reduce(p.coefficients))

proc poly*[A](a: varargs[A]): auto = polynomial("X", a)

proc monomial*[A](I: static[string], n: int, a: A): Polynomial[I, A] =
  var c = newSeq[A](n + 1)
  for i in 0 .. < n:
    c[i] = zero(a)
  c[n] = a
  polynomial(I, c)

template v(symbol, id: untyped): auto {.immediate.} =
  const vname {.gensym.} = symbol
  let id {.inject.} = monomial(vname, 1, 1)

macro variable*(id: untyped): stmt =
  let symbol = newStrLitNode($(id))
  result = getAst(v(symbol, id))

proc deg*[I: static[string], A](p: Polynomial[I, A]): int {.inline.} =
  p.coefficients.len - 1

proc top*[I: static[string], A](p: Polynomial[I, A]): A {.inline.} =
  p.coefficients[deg(p)]

proc `$`*[I: static[string], A](p: Polynomial[I, A]): string =
  result = ""
  var first = true
  for i in 0 .. deg(p):
    let x = p.coefficients[i]
    if x != zero(x):
      if not first: result &= " + "
      first = false
      if i == 0: result &= $(x)
      elif i == 1:
        if x == id(x): result &= I
        else: result &= $(x) & "*" & I
      else:
        if x == id(x): result &= I & "^"  & $(i)
        else: result &= $(x) & "*" & I & "^"  & $(i)

proc zero*(I: static[string], A: typedesc): Polynomial[I, A] =
  Polynomial[I, A](coefficients: @[])

proc zero*[I: static[string], A](x: Polynomial[I, A]): Polynomial[I, A] =
  poly[I, A]()

proc id*[I: static[string], A](x: Polynomial[I, A]): Polynomial[I, A] =
  poly[I, A](id[A]())

proc `==`*[I: static[string], A](p: Polynomial[I, A], q: A): bool =
  (p.deg == -1 and q == zero(q)) or (p.deg == 0 and p.coefficients[0] == q)

proc `==`*[I: static[string], A](p: A, q: Polynomial[I, A]): bool =
  (q.deg == -1 and p == zero(p)) or (q.deg == 0 and q.coefficients[0] == p)

proc sumSeq[A](s, t: seq[A]): seq[A] =
  if s.len >= t.len:
    result = newSeq[A](s.len)
    for i in 0 .. < t.len:
      result[i] = s[i] + t[i]
    for i in t.len .. < s.len:
      result[i] = s[i]
  else: return sumSeq(t, s)

proc `+`*[I: static[string], A](p, q: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, sumSeq(p.coefficients, q.coefficients))

proc `+`*[I: static[string], A](p: Polynomial[I, A], q: A): Polynomial[I, A] =
  p + polynomial(I, q)

proc `+`*[I: static[string], A](p: A, q: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, p) + q

proc `-`*[I: static[string], A](p: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, p.coefficients.map(proc (a: A): A =
    -a))

proc `-`*[I: static[string], A](p, q: Polynomial[I, A]): Polynomial[I, A] =
  p + (-q)

proc `-`*[I: static[string], A](p: Polynomial[I, A], q: A): Polynomial[I, A] =
  p - polynomial(I, q)

proc `-`*[I: static[string], A](p: A, q: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, p) - q

template `+=`*[I: static[string], A](a: var Polynomial[I, A], b: Polynomial[I, A]) =
  let c = a
  a = c + b

template `-=`*[I: static[string], A](a: var Polynomial[I, A], b: Polynomial[I, A]) =
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

proc `*`*[I: static[string], A](p, q: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, mulSeq(p.coefficients, q.coefficients))

proc `*`*[I: static[string], A](p: Polynomial[I, A], q: A): Polynomial[I, A] =
  p * polynomial(I, q)

proc `*`*[I: static[string], A](p: A, q: Polynomial[I, A]): Polynomial[I, A] =
  polynomial(I, p) * q

template `*=`*[I: static[string], A](a: var Polynomial[I, A], b: Polynomial[I, A]) =
  let c = a
  a = c * b

proc division*[I: static[string], A](s, t: Polynomial[I, A]): tuple[q: Polynomial[I, A], r: Polynomial[I, A]] =
  if deg(t) > deg(s): (zero(I, A), s)
  else:
    let
      a = top(s)
      b = top(t)
      q_0 = monomial(I, deg(s) - deg(t), a / b)
      r_0 = reduce(s - (q_0 * t))
      (q_1, r) = division(r_0, t)
    (q_0 + q_1, r)

proc `div`*[I: static[string], A](s, t: Polynomial[I, A]): Polynomial[I, A] =
  let (q, r) = division(s, t)
  q

proc `%%`*[I: static[string], A](s, t: Polynomial[I, A]): Polynomial[I, A] =
  let (q, r) = division(s, t)
  r