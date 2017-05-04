# lkn_prelude: an opiniated prelude for the lkn project
# Copyright (C) 2017 Thomas Letan
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
defmodule Lkn.Prelude.Option do
  @moduledoc """
  An optional value.

  Whenever a function may or may not returns a value, the Option
  macros should be used. In a similar manner, these macros should be
  used in pattern matching blocks. This way, the inner representation
  can change without the refactoring pain.

  The best way to use this module is by calling `use
  Lkn.Prelude`. This call aliases and requires each components of the
  lkn Prelude, including this module.

  ## Example

      use Lkn.Prelude

      x = Option.some(3)
      y = Option.nothing()

      Option.unwrap(x, 1)
      #=> 3
      Option.unwrap!(x)
      #=> 3
      Option.unwrap(y, 1)
      #=> 1
  """

  @typedoc """
  The result of a computation which could have returned something but
  didn't.
  """
  @opaque nothing()  :: :nothing

  @typedoc """
  The result of a computation which could have failed to return
  something but didn't.
  """
  @opaque some(x)    :: {:some, x}

  @typedoc """
  The result of a computation which could have failed or could have
  returned something.
  """
  @type   t(x)       :: some(x)|nothing

  @typedoc """
  The type of an optional value, before a computation.
  """
  @type   a()  :: any()

  @typedoc """
  The type of an optional value, after a computation.
  """
  @type   b()  :: any()

  @spec some(a) :: some(a)
  @doc """
  A macro to create and match an optional value.
  """
  defmacro some(x) do
    quote do
      {:some, unquote(x)}
    end
  end

  @spec nothing() :: nothing
  @doc """
  A macro to create and match a nothing value.
  """
  defmacro nothing do
    quote do
      :nothing
    end
  end

  @doc """
  A macro to execute a block only if the given optional value exists.

  In `expression`, one can use `x`: it gets the value encapsulated in
  `opt`.
  """
  defmacro inside(opt, x, do: expression) do
    quote do
      case unquote(opt) do
        unquote(some(x)) -> unquote(expression)
        unquote(nothing())  -> :ok
      end
    end
  end

  @spec unwrap(t(a), a) :: a
  @doc """
  Get the value contained within a `Lkn.Prelude.Option` or a
  default value.

      iex> Lkn.Prelude.Option.unwrap(Lkn.Prelude.Option.some(3), 1)
      3
      iex> Lkn.Prelude.Option.unwrap(Lkn.Prelude.Option.nothing(), 1)
      1
  """
  def unwrap(x, default) do
    case x do
      some(i) -> i
      nothing() -> default
    end
  end

  @spec unwrap!(some(a)) :: a
  @doc """
  Same as `Lkn.Prelude.Option.unwrap/2`, but panicked if there is no
  value to unwrap.

      iex> Lkn.Prelude.Option.unwrap!(Lkn.Prelude.Option.some(3))
      3
      iex> try do
      ...>   Lkn.Prelude.Option.unwrap!(Lkn.Prelude.Option.nothing())
      ...> rescue
      ...>   _ -> :ok
      ...> end
      :ok
  """
  def unwrap!(some(x)) do
    x
  end
  def unwrap!(nothing()) do
    raise ArgumentError, "Trying to unwrap a `nothing` value"
  end

  @spec map(t(a), (a -> b)) :: t(b)
  @doc """
  Apply a function to an optional value if it exists.

      iex> Lkn.Prelude.Option.map(Lkn.Prelude.Option.some(3), &(&1 + 1))
      Lkn.Prelude.Option.some(4)
  """
  def map(some(x), f) do
    some(f.(x))
  end
  def map(nothing(), _f) do
    nothing()
  end
end
