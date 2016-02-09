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

proc makeMatrix*[A](M, N: int, f: proc(i, j: int): A, order = colMajor): Matrix[A] =
  result.data = newSeq[A](M * N)
  result.M = M
  result.N = N
  result.order = order
  if order == colMajor:
    for i in 0 .. < M:
      for j in 0 .. < N:
        result.data[j * M + i] = f(i, j)
  else:
    for i in 0 .. < M:
      for j in 0 .. < N:
        result.data[i * N + j] = f(i, j)

proc matrix*[A](xs: seq[seq[A]], order = colMajor): Matrix[A] =
  makeMatrix(xs.len, xs[0].len, proc(i, j: int): A = xs[i][j], order)

template `[]`*[A](m: Matrix[A], i, j: int): A =
  if m.order == colMajor: m.data[j * m.M + i]
  else: m.data[i * m.N + j]