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

type
  OrderType* = enum
    rowMajor = 101, colMajor = 102 # consistent with BLAS
  Vector*[A] = seq[A]
  Matrix*[A] = object
    order: OrderType
    M, N: int
    data: seq[A]

proc `+=`*[A: AdditiveGroup](v: var Vector[A], w: Vector[A]) =
  assert v.len == w.len
  for i in 0 .. < v.len:
    v[i] = v[i] + w[i]

proc `+`*[A: AdditiveGroup](v, w: Vector[A]): Vector[A] =
  assert v.len == w.len
  result = newSeq[A](v.len)
  for i in 0 .. < v.len:
    result[i] = v[i] + w[i]

proc `-=`*[A: AdditiveGroup](v: var Vector[A], w: Vector[A]) =
  assert v.len == w.len
  for i in 0 .. < v.len:
    v[i] = v[i] - w[i]

proc `-`*[A: AdditiveGroup](v, w: Vector[A]): Vector[A] =
  assert v.len == w.len
  result = newSeq[A](v.len)
  for i in 0 .. < v.len:
    result[i] = v[i] - w[i]

proc `*`*[A: Ring](v, w: Vector[A]): A =
  assert v.len == w.len
  result = zero(v[0])
  for i in 0 .. < v.len:
    result += v[i] * w[i]

template colM(i, j, M, N: expr): expr = j * M + i
template rowM(i, j, M, N: expr): expr = i * N + j

proc makeMatrix*[A](M, N: int, f: proc(i, j: int): A, order = colMajor): Matrix[A] =
  result.data = newSeq[A](M * N)
  result.M = M
  result.N = N
  result.order = order
  if order == colMajor:
    for i in 0 .. < M:
      for j in 0 .. < N:
        result.data[colM(i, j, M, N)] = f(i, j)
  else:
    for i in 0 .. < M:
      for j in 0 .. < N:
        result.data[rowM(i, j, M, N)] = f(i, j)

proc matrix*[A](xs: seq[seq[A]], order = colMajor): Matrix[A] =
  makeMatrix(xs.len, xs[0].len, proc(i, j: int): A = xs[i][j], order)

template `[]`*[A](m: Matrix[A], i, j: int): A =
  if m.order == colMajor: m.data[colM(i, j, m.M, m.N)]
  else: m.data[rowM(i, j, m.M, m.N)]

template `[]=`*[A](m: Matrix[A], i, j: int, value: A) =
  if m.order == colMajor:
    m.data[colM(i, j, m.M, m.N)] = value
  else:
    m.data[rowM(i, j, m.M, m.N)] = value

proc `==`*[A: AdditiveGroup](m, n: Matrix[A]): bool =
  if (m.M != n.M) or (m.N != n.N): return false
  if m.order == n.order: return m.data == n.data
  if m.order == colMajor:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        if m.data[colM(i, j, m.M, m.N)] != n.data[rowM(i, j, m.M, m.N)]:
          return false
  else:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        if m.data[rowM(i, j, m.M, m.N)] != n.data[colM(i, j, m.M, m.N)]:
          return  false
  return true

proc `+=`*[A: AdditiveGroup](m: var Matrix[A], n: Matrix[A]) =
  assert ((m.M == n.M) and (m.N == n.N))
  if m.order == n.order:
    for i in 0 .. < m.data.len:
      m.data[i] = m.data[i] + n.data[i]
  elif m.order == colMajor:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        m.data[colM(i, j, m.M, m.N)] += n.data[rowM(i, j, m.M, m.N)]
  else:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        m.data[rowM(i, j, m.M, m.N)] += n.data[colM(i, j, m.M, m.N)]

proc `+`*[A: AdditiveGroup](m, n: Matrix[A]): Matrix[A] =
  assert ((m.M == n.M) and (m.N == n.N))
  assert m.data.len == n.data.len
  result = m
  result += n

proc `-=`*[A: AdditiveGroup](m: var Matrix[A], n: Matrix[A]) =
  assert ((m.M == n.M) and (m.N == n.N))
  if m.order == n.order:
    for i in 0 .. < m.data.len:
      m.data[i] = m.data[i] - n.data[i]
  elif m.order == colMajor:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        m.data[colM(i, j, m.M, m.N)] -= n.data[rowM(i, j, m.M, m.N)]
  else:
    for i in 0 .. < m.M:
      for j in 0 .. < m.N:
        m.data[rowM(i, j, m.M, m.N)] -= n.data[colM(i, j, m.M, m.N)]

proc `-`*[A: AdditiveGroup](m, n: Matrix[A]): Matrix[A] =
  assert ((m.M == n.M) and (m.N == n.N))
  assert m.data.len == n.data.len
  result = m
  result -= n

proc `*`*[A: Ring](m: Matrix[A], v: Vector[A]): Vector[A] =
  assert v.len == m.N
  result = newSeq[A](m.M)
  if m.order == colMajor:
    for i in 0 .. < m.M:
      result[i] = zero(m[0, 0])
      for j in 0 .. < m.N:
        result[i] += m.data[colM(i, j, m.M, m.N)] * v[j]
  else:
    for i in 0 .. < m.M:
      result[i] = zero(m[0, 0])
      for j in 0 .. < m.N:
        result[i] += m.data[rowM(i, j, m.M, m.N)] * v[j]

proc t*[A](m: Matrix[A]): Matrix[A] =
  result = Matrix[A](
    M: m.N,
    N: m.M,
    order: (if m.order == colMajor: rowMajor else: colMajor),
    data: nil
  )
  shallowCopy(result.data, m.data)