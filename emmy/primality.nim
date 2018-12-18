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

import intsets, math, algorithm
import ./structures, ./operations, ./modular

# Based on http://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
# Notation:
# - n = 2^s * d is the number under test
# - a is a candidate for a witness of n being composite

# enable BigInt when division is ready
type Integer = int64 or int32 or int # or BigInt

proc mrCoefficients(n: Integer): tuple[s, d: Integer] =
  let
    one = id(type(n))
    two = one + one
  var
    s = zero(type(n))
    d = n
  while d %% two == zero(type(n)):
    s += one
    d = d div two
  (s, d)

proc test(n, a: Integer): bool =
  let
    (s, d) = mrCoefficients(n - 1)
    b = a.modulo(n)
    one = id(type(a)).modulo(n)
  var x = power(b, d)
  if (x == one) or (x == -one): return true
  for i in 0 ..< s:
    x = x * x
    if x == one: return false
    if x == -one: return true
  return false

# The following sets are known deterministically to be enough,
# see the above wikipedia entry and:
# Pomerance, Selfridge, Wagstaff: The pseudoprimes to 25·10^9
#   http://www.math.dartmouth.edu/~carlp/PDF/paper25.pdf
# Jaeschke: On strong pseudoprimes to several bases
proc witnesses(n: Integer): seq[Integer] =
  if n < 2047: @[2]
  elif n < 1373653: @[2, 3]
  elif n < 9080191: @[31, 73]
  elif n < 25326001: @[2, 3, 5]
  elif n < 4759123141: @[2, 7, 61]
  elif n < 1122004669633: @[2, 13, 23, 1662803]
  elif n < 2152302898747: @[2, 3, 5, 7, 11]
  elif n < 3474749660383: @[2, 3, 5, 7, 11, 13]
  elif n < 341550071728321: @[2, 3, 5, 7, 11, 13, 17]
  else: @[2, 3, 5, 7, 11, 13, 17, 19, 23]
  # if n < 3,825,123,056,546,413,051, it is enough to test a = 2, 3, 5, 7, 11, 13, 17, 19, and 23.

proc millerRabinTest*(n: Integer): bool =
  if n <= 1: return false
  if n == 2: return true
  for a in n.witnesses:
    if not test(n, a): return false
  return true # probably

# Based on http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

# Returns the list of all numbers up to n
# that are not multiple of a prime below a
proc sieveUpTo(a, n: int): IntSet =
  result = initIntSet()
  var composites = initIntSet()
  for i in 2 .. a:
    if not composites.contains(i):
      result.incl(i)
      for j in countup(i * i, n, i):
        composites.incl(j)
  for i in a + 1 .. n:
    if not composites.contains(i):
      result.incl(i)

proc primesUpTo*(n: int): IntSet = sieveUpTo(int(float(n).sqrt), n)

proc sortedPrimesUpTo(n: int): seq[int] =
  result = @[]
  for p in primesUpTo(n):
    result.add(p)
  sort(result, system.cmp[int])

# const maxPreComputed = 10000
# const primesUpToOneMax: IntSet = primesUpTo(maxPreComputed)

proc isPrime*(n: int): bool =
  if n <= 1: false
  # elif n <= maxPreComputed: primesUpToOneMax.contains(n)
  elif n <= 100000: primesUpTo(n).contains(n)
  else: millerRabinTest(n)

# May be nil
proc nextPrime*(n: int): int =
  if n <= 2: return 2
  let bound = n * ln(n.float).int
  for i in sortedPrimesUpTo(bound):
    if i >= n: return i
  # return nil

type PrimeRadix* = object
  case isPrimePower*: bool
  of true:
    p*, k*: int
  of false:
    discard

proc findPrimePower*(n: int): PrimeRadix =
  let nf = n.float
  for k in countdown(log2(nf).int, 1):
    let p = pow(nf, 1 / k).round.int
    if p ^ k == n and p.isPrime:
      return PrimeRadix(isPrimePower: true, p: p, k: k)
  return PrimeRadix(isPrimePower: false)

proc primeRadix*(n: int): int =
  let x = findPrimePower(n)
  if x.isPrimePower: return x.p
  else: return 0

proc isPrimePower*(n: int): bool =
 findPrimePower(n).isPrimePower