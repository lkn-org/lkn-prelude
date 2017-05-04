# lkn-prelude

This package is an opinionated Prelude for the [lkn project](http://lkn.ist). It
is designed to fit lkn needs, but if it brings you what you need, feel free to
use it.

## Guide

Every module of this package is in the `Lkn.Prelude` namespace to avoid name
collision. If one wants to adopt our opinionated point of view, all she has to do
is to add the following line to her code:

```elixir
use Lkn.Prelude
```

After that, the modules are aliased and required, which means they can be used
painlessly.

## Prelude’s Principles

### Opaque data-structures and macro-based pattern matching

In Elixir, it is not rare to see the most common data structure defined as
tuples. For instance, a computation that may or may not return a value will
effectively return `{ :ok, val } | :error`. As a consequence, the caller will
have to match the result:

```elixir
case res do
  {:ok, val} ->
    # ...
  _ ->
    # ...
end
```

From our perspective, it brings several issues. The main one is
inconsistency. Some code might return `{:ok, val}` in case of success where
other would return `{:some, val}`. Another is that it makes it harder to change
the data structure implementation. For instance, what if one wants to return a
structure rather than a tuple, in order to implement the `Enumerable` protocol?

This package takes another path. The data structure typespecs are opaque and the
constructors are implemented as macros. The main benefit is macros can be used
to match a value.

```elixir
case res do
  Option.some(x) ->
    # ...
  Option.nothing() ->
    # ...
end
```

### Parameterized Typespecs

Most of the time, the data structure typespecs in Elixir are not parameterized
by the type of the content. In this package, they are. In addition, the data
structure modules define two types: `a` and `b` which are aliases to `any`. From
dialyzer point of view, they bring no additional information and mixing them
does not raise any warning. However, from a developer point of view, it can
bring more information about the real behaviour of a function:

That is, we believe `@spec map(t(a), (a -> b)) :: t(b)` is more expressive and
useful than `@spec map(t(any), (any -> any)) :: t(any)` or `@spec map(t, (any ->
any)) :: t`.
