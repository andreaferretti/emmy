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

# Binary ladder, unsafe against timing attacks
# We should replace it with a safe Montgomery ladder, see
# http://cr.yp.to/bib/2003/joye-ladder.pdf

proc power*(r: Ring, n: int): auto =
  mixin id
  var
    n = n
    s = r
  result = id(r)
  while n > 0:
    if n %% 2 == 1:
      result = result * s
    s = s * s
    n = n div 2

template `^`*(r: Ring, n: int): r.type = power(r, n)

proc gcd*(r, s: EuclideanRing): auto =
  var
    a = r
    b = s
  while b != 0:
    let q = a %% b
    a = b
    b = q
  return a