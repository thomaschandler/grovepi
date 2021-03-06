defmodule GrovePi.Buttons.Supervisor do
  use Supervisor
  @moduledoc false

  @name __MODULE__

  @spec start_link(pid, Supervisor.options) :: Supervisor.on_start
  def start_link(grove_pi_pid, opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    Supervisor.start_link(__MODULE__, [grove_pi_pid], opts)
  end

  def init([grove_pi_pid]) do
    children = [
      worker(GrovePi.Button, [grove_pi_pid]),
    ]

    supervise(children, strategy: :simple_one_for_one, restart: :transient)
  end

  @spec add(GrovePi.Buttons.pin) :: Supervisor.start_child
  def add(pin, name \\ @name) do
    Supervisor.start_child(name, [pin])
  end
end
