defmodule Clock.CoreTest do
  use ExUnit.Case
  alias Clock.Core

  test "constructs spi transfers" do
    transfers = %{hour: 12, minute: 34, second: 56} |> Core.new() |> Core.to_leds(:spi)

    assert transfers == [
             <<0x02>>,
             <<0x40>>,
             <<0xC0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0>>,
             <<0x89>>
           ]
  end
end
