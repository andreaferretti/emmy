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

import strformat
import neo/dense
import ./structures

proc `+=`*[A: AdditiveGroup](v: var Vector[A], w: Vector[A]) =
  assert v.len == w.len
  for i in 0 ..< v.len:
    v[i] = v[i] + w[i]

proc `+`*[A: AdditiveGroup](v, w: Vector[A]): Vector[A] =
  assert v.len == w.len
  result = vector(newSeq[A](v.len))
  for i in 0 ..< v.len:
    result[i] = v[i] + w[i]

proc `-=`*[A: AdditiveGroup](v: var Vector[A], w: Vector[A]) =
  assert v.len == w.len
  for i in 0 ..< v.len:
    v[i] = v[i] - w[i]

proc `-`*[A: AdditiveGroup](v, w: Vector[A]): Vector[A] =
  assert v.len == w.len
  result = vector(newSeq[A](v.len))
  for i in 0 ..< v.len:
    result[i] = v[i] - w[i]

proc `*`*[A: Ring](v, w: Vector[A]): A =
  assert v.len == w.len
  result = zero(A)
  for i in 0 ..< v.len:
    result += v[i] * w[i]

template colM(i, j, M, N: auto): auto = j * M + i
template rowM(i, j, M, N: auto): auto = i * N + j

proc `+=`*[A: AdditiveGroup](m: var Matrix[A], n: Matrix[A]) =
  assert((m.M == n.M) and (m.N == n.N))
  if m.order == n.order:
    for i in 0 ..< m.data.len:
      m.data[i] = m.data[i] + n.data[i]
  elif m.order == colMajor:
    for i in 0 ..< m.M:
      for j in 0 ..< m.N:
        m.data[colM(i, j, m.M, m.N)] += n.data[rowM(i, j, m.M, m.N)]
  else:
    for i in 0 ..< m.M:
      for j in 0 ..< m.N:
        m.data[rowM(i, j, m.M, m.N)] += n.data[colM(i, j, m.M, m.N)]

proc `+`*[A: AdditiveGroup](m, n: Matrix[A]): Matrix[A] =
  assert((m.M == n.M) and (m.N == n.N))
  result = m.clone()
  result += n

proc `-=`*[A: AdditiveGroup](m: var Matrix[A], n: Matrix[A]) =
  assert((m.M == n.M) and (m.N == n.N))
  if m.order == n.order:
    for i in 0 ..< m.data.len:
      m.data[i] = m.data[i] - n.data[i]
  elif m.order == colMajor:
    for i in 0 ..< m.M:
      for j in 0 ..< m.N:
        m.data[colM(i, j, m.M, m.N)] -= n.data[rowM(i, j, m.M, m.N)]
  else:
    for i in 0 ..< m.M:
      for j in 0 ..< m.N:
        m.data[rowM(i, j, m.M, m.N)] -= n.data[colM(i, j, m.M, m.N)]

proc `-`*[A: AdditiveGroup](m, n: Matrix[A]): Matrix[A] =
  assert((m.M == n.M) and (m.N == n.N))
  result = m.clone()
  result -= n

proc `*`*[A: Ring](m: Matrix[A], v: Vector[A]): Vector[A] =
  assert v.len == m.N
  result = vector(newSeq[A](m.M))
  if m.order == colMajor:
    for i in 0 ..< m.M:
      result[i] = zero(A)
      for j in 0 ..< m.N:
        result[i] = result[i] + m.data[colM(i, j, m.M, m.N)] * v[j]
  else:
    for i in 0 ..< m.M:
      result[i] = zero(A)
      for j in 0 ..< m.N:
        result[i] = result[i] + m.data[rowM(i, j, m.M, m.N)] * v[j]

template multiply(result, m, n, data_m, data_n: auto) =
  for i in 0 ..< result.M:
    for j in 0 ..< result.N:
      result.data[colM(i, j, result.M, result.N)] = zero(type(m.data[0]))
      for k in 0 ..< m.N:
        result.data[colM(i, j, result.M, result.N)] += m.data[data_m(i, k, m.M, m.N)] * n.data[data_n(k, j, n.M, n.N)]

proc `*`*[A: Ring](m, n: Matrix[A]): Matrix[A] =
  assert m.N == n.M
  result = Matrix[A](
    M: m.M,
    N: n.N,
    order: colMajor,
    data: newSeq[A](m.M * n.N)
  )
  if m.order == colMajor and n.order == colMajor: multiply(result, m, n, colM, colM)
  elif m.order == colMajor and n.order == rowMajor: multiply(result, m, n, colM, rowM)
  elif m.order == rowMajor and n.order == colMajor: multiply(result, m, n, rowM, colM)
  else: multiply(result, m, n, rowM, rowM)

export dense