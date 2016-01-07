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

import emmy, unittest

suite "test Miller-Rabin implementation":
  test "primes will be primes":
    check(2.millerRabinTest)
    check(3.millerRabinTest)
    check(5.millerRabinTest)
    check(7.millerRabinTest)
    check(11.millerRabinTest)
    check(13.millerRabinTest)
    check(17.millerRabinTest)
    check(23.millerRabinTest)
    check(4637.millerRabinTest)
    check(1662803.millerRabinTest)

  test "composites will be composites":
    check(not 0.millerRabinTest)
    check(not 1.millerRabinTest)
    check(not 4.millerRabinTest)
    check(not 6.millerRabinTest)
    check(not 341.millerRabinTest)
    check(not 537.millerRabinTest)
    check(not 3551.millerRabinTest)
    check(not 131281.millerRabinTest)
    check(not 45514613.millerRabinTest)

suite "test primality check":
  test "primes will be primes":
    check(2.isPrime)
    check(3.isPrime)
    check(5.isPrime)
    check(7.isPrime)
    check(11.isPrime)
    check(13.isPrime)
    check(17.isPrime)
    check(23.isPrime)
    check(4637.isPrime)
    check(1662803.isPrime)

  test "composites will be composites":
    check(not 0.isPrime)
    check(not 1.isPrime)
    check(not 4.isPrime)
    check(not 6.isPrime)
    check(not 341.isPrime)
    check(not 537.isPrime)
    check(not 3551.isPrime)
    check(not 131281.isPrime)
    check(not 45514613.isPrime)

  test "we can compute the next prime":
    check((-25).nextPrime == 2)
    check(15.nextPrime == 17)
    check(95.nextPrime == 97)
    check(200.nextPrime == 211)
    check(130538.nextPrime == 130547)