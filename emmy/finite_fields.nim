import macros, ast_pattern_matching
import ./structures, ./primality, ./operations, ./polynomials

## The following type is meant to be used when the modulo is known
## statically. It has better properties than its dynamic counterpart -
## in particular we can make it into a ring. Unfortunately, due this bug
## https://github.com/nim-lang/Nim/issues/7209
## we can only define it for a given concrete type - here `int`.
type Modulo*[N: static[int]] = distinct int

proc `$`*[N: static[int]](x: Modulo[N]): string =
  $(int(x)) & " mod " & $(N)

proc pp*[N: static[int]](x: Modulo[N]): string = $(int(x))

proc pmod*(a: int, N: static[int]): Modulo[N] = Modulo[N](a mod N)

proc `+`*[N: static[int]](x, y: Modulo[N]): Modulo[N] =
  (int(x) + int(y)).pmod(N)

proc `-`*[N: static[int]](x, y: Modulo[N]): Modulo[N] =
  (int(x) - int(y)).pmod(N)

proc `-`*[N: static[int]](x: Modulo[N]): Modulo[N] =
  (N - int(x)).pmod(N)

proc `*`*[N: static[int]](x, y: Modulo[N]): Modulo[N] =
  (int(x) * int(y)).pmod(N)

proc inv*[N: static[int]](a: Modulo[N]): Modulo[N] =
  when isPrime(N):
    if a.int mod N == 0:
      raise newException(DivByZeroError, "Division by 0")
    else:
      let (x, _) = gcdCoefficients(a.int, N)
      return x.pmod(N)
  else:
    {.error: $(N) & " is not prime".}

proc `/`*[N: static[int]](x, y: Modulo[N]): Modulo[N] =
  x * inv(y)

proc `==`*[N: static[int]](x, y: Modulo[N]): bool =
  (x.int - y.int) mod N == 0

proc zero*[N: static[int]](T: type Modulo[N]): T = 0.pmod(N)

proc id*[N: static[int]](T: type Modulo[N]): T = 1.pmod(N)

template `+=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c + b

template `-=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c - b

template `*=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c * b

template `/=`*[N: static[int]](a: var Modulo[N], b: Modulo[N]) =
  let c = a
  a = c / b