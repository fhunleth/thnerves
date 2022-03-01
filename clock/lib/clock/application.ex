defmodule Clock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clock.Supervisor]

    children = [{Clock.Server, Application.get_all_env(:clock)}]

    Supervisor.start_link(children, opts)
  end

  def target() do
    Application.get_env(:clock, :target)
  end
end
