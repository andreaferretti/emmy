Emmy
====

Algebraic structures and related operations for Nim.

![logo](https://raw.githubusercontent.com/unicredit/emmy/master/emmy.png)

Status
------

This library was extracted from a separate project, and will require some
polish. Expect the API to change (hopefully for the better!) until further
notice. :-)

Documentation
-------------

Not too much in terms of documentation yet, but you can see the tests
to get an idea.

Algebraic structures
--------------------

The first building block for Emmy are definitions for common algebraic
structures, such as monoids or Euclidean rings. Such structures are encoded
using [concepts](http://nim-lang.org/docs/manual.html#generics-concepts),
which means that they can be used as generic constraints (say, a certain
operation only works over fields).

The definitions for those concepts follow closely the usual definitions in
mathematics:

```nim
type
  AdditiveMonoid* = concept x, y
    x + y is type(x)
    zero(type(x)) is type(x)
  AdditiveGroup* = concept x, y
    x is AdditiveMonoid
    -x is type(x)
    x - y is type(x)
  MultiplicativeMonoid* = concept x, y
    x * y is type(x)
    id(type(x)) is type(x)
  MultiplicativeGroup* = concept x, y
    x is MultiplicativeMonoid
    x / y is type(x)
  Ring* = concept x
    x is AdditiveGroup
    x is MultiplicativeMonoid
  EuclideanRing* = concept x, y
    x is Ring
    x div y is type(x)
    x mod y is type(x)
  Field* = concept x
    x is Ring
    x is MultiplicativeGroup
```

We notice a couple of ways where the mechanical encoding strays from the
mathematical idea:

* first, the definition above only requires the existence of appropriate
  operations, and we cannot say anything in general about the various axioms
  that these structures satisfy, such as associativity or commutativity;
* second, the division is mathematically only defined for non-zero
  denominators, but we have no way to enforce this at the level of types.

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