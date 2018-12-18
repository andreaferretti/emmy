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

import ./structures, ./linear, ./operations

template skipZeroRows(m, i, j: untyped): untyped =
  block loop:
    while i < m.M:
      for h in j ..< m.N:
        if m[i, h] != 0:
          break loop
      inc(i)

template skipZeroColumns(m, i, j: untyped): untyped =
  block loop:
    while j < m.N:
      for h in i ..< m.M:
        if m[h, j] != 0:
          break loop
      inc(j)

# Swap rows i and k in m, assuming all zeros to the left of j
template swapRows(m, i, k, j: untyped): untyped =
  for L in j ..< m.N:
    let
      x = m[i, L]
      y = m[k, L]
    m[i, L] = y
    m[k, L] = x

template putNonZeroInTheCorner(m, i, j: untyped): untyped =
  var k = i
  while k < m.M and m[k, j] == 0:
    inc(k)
  if k != i and k < m.M:
    swapRows(m, i, k, j)

template stepGcdRows(m, i, j: untyped): untyped =
  for k in i+1 ..< m.M:
    let
      a = m[i, j]
      b = m[k, j]
    if b != 0:
      let
        gcd = extendedGcd(a, b)
        x1 = gcd.x
        y1 = gcd.y
        g = gcd.gcd
      let
        x2 = b div g
        y2 = -a div g
      for L in j ..< m.N:
        let
          f = x1 * m[i, L] + y1 * m[k, L]
          g = x2 * m[i, L] + y2 * m[k, L]
        m[i, L] = f
        m[k, L] = g

template stepGcdColumns(m, i, j: untyped): untyped =
  for k in j+1 ..< m.N:
    let
      a = m[i, j]
      b = m[i, k]
    if b != 0:
      let
        gcd = extendedGcd(a, b)
        x1 = gcd.x
        y1 = gcd.y
        g = gcd.gcd
      let
        x2 = b div g
        y2 = -a div g
      for L in i ..< m.M:
        let
          f = x1 * m[L, j] + y1 * m[L, k]
          g = x2 * m[L, j] + y2 * m[L, k]
        m[L, j] = f
        m[L, k] = g

template increaseIndices(m, i, j: untyped): untyped =
  var allZeros = true
  for k in j + 1 ..< m.N:
    if m[i, k] != 0:
      allZeros = false
      break
  if allZeros:
    for k in i + 1 ..< m.M:
      if m[k, j] != 0:
        allZeros = false
        break
  if allZeros:
    inc(i)
    inc(j)

#TODO: also return the matrix of change of basis
# pay attention to the sign changes
proc smithInPlace*[A: EuclideanRing](m: var Matrix[A]) =
  var
    i = 0
    j = 0
  while i < m.M and j < m.N:
    skipZeroRows(m, i, j)
    skipZeroColumns(m, i, j)
    putNonZeroInTheCorner(m, i, j)
    stepGcdRows(m, i, j)
    stepGcdColumns(m, i, j)
    increaseIndices(m, i, j)