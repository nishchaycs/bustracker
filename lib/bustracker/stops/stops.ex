defmodule Bustracker.Stops do
  @moduledoc """
  The Stops context.
  """

  import Ecto.Query, warn: false
  alias Bustracker.Repo

  alias Bustracker.Stops.Stop

  @doc """
  Returns the list of stops.

  ## Examples

      iex> list_stops()
      [%Stop{}, ...]

  """
  def list_stops do
    Repo.all(Stop)
  end

  @doc """
  Gets a single stop.

  Raises `Ecto.NoResultsError` if the Stop does not exist.

  ## Examples

      iex> get_stop!(123)
      %Stop{}

      iex> get_stop!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stop!(id), do: Repo.get!(Stop, id)

  def get_stops do
    stops = list_stops
    Enum.map(stops, fn stop -> %{ stop_id: stop.stopid, stop_name: stop.stopname} end)
  end

  def get_stop_latitude_by_stopid(id) do
    stop = Repo.get_by(Stop, stopid: id)
    stop.latitude
  end
  def get_stop_longitude_by_stopid(id) do
    stop = Repo.get_by(Stop, stopid: id)
    stop.longitude
  end

  @doc """
  Creates a stop.

  ## Examples

      iex> create_stop(%{field: value})
      {:ok, %Stop{}}

      iex> create_stop(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stop(attrs \\ %{}) do
    %Stop{}
    |> Stop.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stop.

  ## Examples

      iex> update_stop(stop, %{field: new_value})
      {:ok, %Stop{}}

      iex> update_stop(stop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stop(%Stop{} = stop, attrs) do
    stop
    |> Stop.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stop.

  ## Examples

      iex> delete_stop(stop)
      {:ok, %Stop{}}

      iex> delete_stop(stop)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stop(%Stop{} = stop) do
    Repo.delete(stop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stop changes.

  ## Examples

      iex> change_stop(stop)
      %Ecto.Changeset{source: %Stop{}}

  """
  def change_stop(%Stop{} = stop) do
    Stop.changeset(stop, %{})
  end
end
