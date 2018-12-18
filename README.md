# Emmy

Algebraic structures and related operations for Nim.

![logo](https://raw.githubusercontent.com/unicredit/emmy/master/emmy.png)

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Emmy](#emmy)
	- [Status](#status)
	- [Algebraic structures](#algebraic-structures)
		- [Default instances](#default-instances)
		- [Making your own algebraic structures](#making-your-own-algebraic-structures)
	- [Modular rings](#modular-rings)
	- [Quotient rings](#quotient-rings)
	- [Primality](#primality)
	- [Polynomials](#polynomials)
	- [Linear algebra](#linear-algebra)
	- [Finite fields](#finite-fields)

<!-- /TOC -->

## Status

This library was extracted from a separate project, and will require some
polish. Expect the API to change (hopefully for the better!) until further
notice. :-)

There is not too much in terms of documentation yet, but you can see the tests
to get an idea.

## Algebraic structures

The first building block for Emmy are definitions for common algebraic
structures, such as monoids or Euclidean rings. Such structures are encoded
using [concepts](http://nim-lang.org/docs/manual.html#generics-concepts),
which means that they can be used as generic constraints (say, a certain
operation only works over fields).

The definitions for those concepts follow closely the usual definitions in
mathematics:

```nim
type
  AdditiveMonoid* = concept x, y, type T
    x + y is T
    zero(T) is T
  AdditiveGroup* = concept x, y, type T
    T is AdditiveMonoid
    -x is T
    x - y is T
  MultiplicativeMonoid* = concept x, y, type T
    x * y is T
    id(T) is T
  MultiplicativeGroup* = concept x, y, type T
    T is MultiplicativeMonoid
    x / y is T
  Ring* = concept type T
    T is AdditiveGroup
    T is MultiplicativeMonoid
  EuclideanRing* = concept x, y, type T
    T is Ring
    x div y is T
    x mod y is T
  Field* = concept type T
    T is Ring
    T is MultiplicativeGroup
```

We notice a couple of ways where the mechanical encoding strays from the
mathematical idea:

* first, the definition above only requires the existence of appropriate
  operations, and we cannot say anything in general about the various axioms
  that these structures satisfy, such as associativity or commutativity;
* second, the division is mathematically only defined for non-zero
  denominators, but we have no way to enforce this at the level of types.

### Default instances

A few common data types implement the above concepts:

* all standard integer types (`int`, `int32`, `int64`) are instances of
  `EuclideanRing`;
* Emmy depends on [bigints](https://github.com/def-/nim-bigints), and
  `BigInt` is an `EuclideanRing` as well;
* all float types are instances of `Field`;
* `TableRef[K, V]` is an instance of `AdditiveMonoid`, provided `V` is.

The latter uses the sum on values corresponding to the same keys, so that for
instance

```nim
{ "a": 1, "b": 2 }.newTable + { "c": 3, "b": 5 }.newTable == { "a": 1, "c": 3, "b": 7 }.newTable
```

### Making your own algebraic structures

In order to make your data types a member of these concepts, just give
definitions for the appropriate operations.

The line `zero(type(x)) is type(x)` may look confusing at first. This means
that - in order for a type `A` to be a monoid - you have to implement a function
of type `proc(x: typedesc[A]): A`. For instance, for `int` we have

```nim
proc zero*(x: typedesc[int]): int = 0
```

and this allows us to call it like

```nim
zero(int) # returns 0
```

A similar remark holds for `id(type(x)) is type(x)`.

### Cartesian products

The product of two additive (resp. multiplicative) monoids is itself an
additive (resp. multiplicative) monoid. The same holds for additive
groups and for rings (but not for fields!).

Emmy defines suitable operations on pairs of elements, so that tuples with
two elements live in an appropriate algebraic structure, provided each
component does. Hence, for instance, `(int, float64)` is a ring, and

```nim
(1, 2.0) + (3, 4.0) == (4, 6.0)
(1, 2.0) * (3, 4.0) == (3, 8.0)
zero((int, float64)) == (0, 0.0)
```

For products with more than two factors, you can either define your own
instances or work recursively, using the isomorphism between `(A, B, C)` and
`((A, B), C)`.

## Modular rings

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tmodular.nim)

## Fraction rings

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tfractions.nim)

## Primality

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tprimality.nim)

## Polynomials

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tpolynomials.nim)

## Linear algebra

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tlinear.nim)

## Finite fields

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tfinite_fields.nim)

## Normal forms of matrices

To be documented, see [tests](https://github.com/unicredit/emmy/blob/master/tests/tnormal_forms.nim)