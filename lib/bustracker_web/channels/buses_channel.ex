defmodule BustrackerWeb.BusesChannel do
  use BustrackerWeb, :channel

  def join("buses:"<>id, payload, socket) do

    if authorized?(payload) do
      if Bustracker.BusAgent.load(id) do
        IO.puts("insideload")
        Bustracker.BusinfoGens.handle_join()
        {:ok, socket}
      else
        {:ok, pid} = Bustracker.BusinfoGens.start_link(id)
        Bustracker.BusAgent.save(id, pid)
        {:ok, socket}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def terminate(_reason, socket) do
    Bustracker.BusinfoGens.handle_leave()
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (buses:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end