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

  test "we can find radicals of prime powers":
    check(2.primeRadix == 2)
    check(3.primeRadix == 3)
    check(4.primeRadix == 2)
    check(5.primeRadix == 5)
    check(6.primeRadix == 0)
    check(8.primeRadix == 2)
    check(9.primeRadix == 3)
    check(10.primeRadix == 0)
    check(16.primeRadix == 2)
    check(32.primeRadix == 2)
    check(125.primeRadix == 5)
    check(243.primeRadix == 3)
    check(2048.primeRadix == 2)

  test "we can detect prime powers":
    check(2.isPrimePower)
    check(3.isPrimePower)
    check(4.isPrimePower)
    check(5.isPrimePower)
    check(not 6.isPrimePower)
    check(8.isPrimePower)
    check(9.isPrimePower)
    check(not 10.isPrimePower)
    check(16.isPrimePower)
    check(32.isPrimePower)
    check(125.isPrimePower)
    check(243.isPrimePower)
    check(2048.isPrimePower)