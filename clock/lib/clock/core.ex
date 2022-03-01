defmodule Clock.Core do
  defstruct ~w[hours minutes seconds]a
  @brightness 1

  def new(%{hour: hours, minute: minutes, second: seconds}) do
    %__MODULE__{
      hours: hours,
      minutes: minutes,
      seconds: seconds
    }
  end

  def to_leds(clock, format \\ :bytes) do
    [
      tens(clock.hours),
      ones(clock.hours),
      tens(clock.minutes),
      ones(clock.minutes),
      tens(clock.seconds),
      ones(clock.seconds)
    ]
    |> formatter(format)
  end

  defp tens(x), do: div(x, 10)
  defp ones(x), do: rem(x, 10)

  defp formatter(list, :none), do: list
  defp formatter(list, :pretty), do: pretty(list)
  defp formatter(list, :spi), do: to_spi(list)

  defp to_pretty_byte(x) when x >= 0 and x <= 9, do: "#{x}"
  defp to_pretty_byte(_), do: "?"

  defp to_spi(list) do
    # TM1620 protocol for setting LEDs
    #
    # 1. Send `0x02` - Set up the TM1620 for 8 segment, 6 digit mode. The TM1620 is connected so each binary digit is one TM1620 "digit"
    # 2. Send `0x40` - Tell the TM1620 to auto increment digits when written
    # 3. Send `0xC0 hours 0 hours 0 minutes 0 minutes 0 seconds 0 seconds` - The hours, minutes, and seconds are the bits to show. The `0`'s are part of the TM1620 protocol.
    # 4. Send `0x88 + brightness` - This turns the LEDs on and sets their brightness from `0` (dim) to `7` (bright)

    led_settings = for bits <- list, into: "", do: <<bits, 0>>
    [<<0x02>>, <<0x40>>, <<0xC0>> <> led_settings, <<0x88 + @brightness>>]
  end

  defp pretty(list) do
    for bits <- list, into: "", do: to_pretty_byte(bits)
  end
end
