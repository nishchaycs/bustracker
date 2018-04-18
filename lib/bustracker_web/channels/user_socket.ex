defmodule BustrackerWeb.UserSocket do
  use Phoenix.Socket
  alias Bustracker.Users

  ## Channels
  # channel "room:*", BustrackerWeb.RoomChannel
  channel "travellers:*", BustrackerWeb.TravellersChannel
  channel "buses:*", BustrackerWeb.BusesChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.


  def connect(%{"register" => user_params}, socket) do
    IO.puts "connect called"
    IO.inspect user_params

    case Users.create_user(user_params) do
      {:ok, user} ->
        token = Phoenix.Token.sign(socket,"token", user.id)
        {:ok, assign(socket, :token, token)}
      {:error, changeset} ->
        :error
    end
  end

  def connect(%{"login" => user_params}, socket) do
    IO.inspect user_params
    user = Users.get_user_by_email(user_params["emailid"])

    case user do
      nil -> :error
      _ ->
        token = Phoenix.Token.sign(socket, "token", user.id)
        {:ok, assign(socket, :token, token)}
    end
  end

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "token", token, max_age: 86400) do
      {:ok, userid} ->
        {:ok, assign(socket, :token, token)}
      {:error, :expired} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     BustrackerWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end

