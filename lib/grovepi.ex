defmodule GrovePi do
  @moduledoc """
  Low-level interface for sending raw requests and receiving responses from a
  GrovePi hat. Create one of these first and then use one of the other GrovePi
  modules for interacting with a connected sensor, light, or actuator.

  To check that your GrovePi hardware is working, try this:

  ```
  iex> {:ok, pid}=GrovePi.start_link()
  {:ok, #PID<0.212.0>}
  iex> GrovePi.firmware_version(pid)
  "1.2.2"
  ```

  """

  @grovepi_address 0x04
  use GrovePi.I2C

  @doc """
  """
  @spec start_link(byte) :: {:ok, pid} | {:error, any}
  def start_link(address \\ @grovepi_address) when is_integer(address) do
    @i2c.start_link("i2c-1", address)
  end

  @doc """
  Get the version of firmware running on the GrovePi's microcontroller.
  """
  @spec firmware_version(pid) :: binary | {:error, term}
  def firmware_version(pid) do
    with :ok <- send_request(pid, <<8, 0, 0, 0>>),
         <<_, major, minor, patch>> <- get_response(pid, 4),
         do: "#{major}.#{minor}.#{patch}"
  end

  @doc """
  Send a request to the GrovePi. This is not normally called directly
  except when interacting with an unsupported sensor.
  """
  @spec send_request(pid, binary) :: :ok
  def send_request(pid, message) when byte_size(message) == 4 do
    @i2c.write(pid, message)
  end

  @doc """
  Get a response to a previously send request to the GrovePi. This is
  not normally called directly.
  """
  def get_response(pid, len) do
    @i2c.read(pid, len)
  end
end
