defmodule Clock.Adapter.Target do
  defstruct [:time, :spi]
  alias Clock.Core
  alias Circuits.SPI

  def open(bus, time) do
    :timer.send_interval(1_000, :tick)

    bus = bus || hd(SPI.bus_names())
    {:ok, spi} = SPI.open(bus, mode: 3, lsb_first: true)
    %__MODULE__{time: time, spi: spi}
  end

  def show(adapter, time) do
    adapter
    |> Map.put(:time, time)
    |> transfer()
  end

  defp transfer(adapter) do
    adapter.time
    |> Core.new()
    |> Core.to_leds(:spi)
    |> Enum.each(&SPI.transfer!(adapter.spi, &1))

    adapter
  end
end
