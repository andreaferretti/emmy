import macros
import ./structures, ./primality, ./operations

template finiteField*(N: int): untyped =
  type ModuloN = distinct int

  proc `+`(a, b: ModuloN): ModuloN =
    ModuloN((a.int + b.int) mod N)

  proc `-`(a, b: ModuloN): ModuloN =
    ModuloN((a.int - b.int) mod N)

  proc `*`(a, b: ModuloN): ModuloN =
    ModuloN((a.int * b.int) mod N)

  when isPrime(N):
    proc inv(a: ModuloN): ModuloN =
      if a.int mod N == 0:
        raise newException(DivByZeroError, "Division by 0")
      else:
        let (x, y) = gcdCoefficients(a.int, N)
        return ModuloN(x)

    proc `/`(a, b: ModuloN): ModuloN =
      a * inv(b)

  proc `==`(a, b: ModuloN): bool =
    (a.int - b.int) mod N == 0

  proc `$`(a: ModuloN): string =
    $(a.int) & " (mod " & $(N) & ")"

macro modular*(n: static int, typeName: untyped): untyped =
  result = getAst(finiteField(n))
  let typeSymbol = result[0][0][0]
  let exported = quote do:
    type `typeName` = `typeSymbol`
  result.add(exported)
  when defined(emmyDebug):
    echo result.toStrLit

modular(2, Modulo2)
modular(3, Modulo3)
modular(4, Modulo4)
modular(5, Modulo5)
modular(6, Modulo6)
modular(7, Modulo7)
modular(8, Modulo8)
modular(9, Modulo9)
modular(10, Modulo10)
modular(11, Modulo11)
modular(12, Modulo12)
modular(13, Modulo13)
modular(14, Modulo14)
modular(15, Modulo15)
modular(16, Modulo16)
modular(17, Modulo17)
modular(18, Modulo18)
modular(19, Modulo19)
modular(20, Modulo20)
modular(21, Modulo21)
modular(22, Modulo22)
modular(23, Modulo23)
modular(24, Modulo24)
modular(25, Modulo25)
modular(26, Modulo26)
modular(27, Modulo27)
modular(28, Modulo28)
modular(29, Modulo29)
modular(30, Modulo30)
modular(31, Modulo31)
modular(32, Modulo32)
modular(64, Modulo64)
modular(128, Modulo128)
modular(256, Modulo256)
modular(512, Modulo512)
modular(1024, Modulo1024)
modular(2048, Modulo2048)

export Modulo2
export Modulo3
export Modulo4
export Modulo5
export Modulo6
export Modulo7
export Modulo8
export Modulo9
export Modulo10
export Modulo11
export Modulo12
export Modulo13
export Modulo14
export Modulo15
export Modulo16
export Modulo17
export Modulo18
export Modulo19
export Modulo20
export Modulo21
export Modulo22
export Modulo23
export Modulo24
export Modulo25
export Modulo26
export Modulo27
export Modulo28
export Modulo29
export Modulo30
export Modulo31
export Modulo32
export Modulo64
export Modulo128
export Modulo256
export Modulo512
export Modulo1024
export Modulo2048
export `+`, `-`, `*`, `/`, inv, `==`, `$`