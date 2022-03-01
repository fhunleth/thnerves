defmodule AdapterTest do
  use ExUnit.Case
  import Clock.Adapter.Test

  test "Tracks time" do
    adapter =
      open(:unused, ~T[20:13:17.304475])
      |> show(~T[01:02:04.0])
      |> show(~T[01:02:05.0])

    [second, first] = adapter.bits

    assert [0, 1, 0, 2, 0, 4] = first
    assert [0, 1, 0, 2, 0, 5] = second
  end
end
