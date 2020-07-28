defmodule Metex.Worker do
  use GenServer

  @apiKey "943a521e014077c40464a3f28c37cb36"
  @name MW

  # API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def get_temprature(location) do
    GenServer.call(@name, {:location, location})
  end

  def stop() do
    GenServer.cast(@name, :stop)
  end

  def terminate(reason, state) do
    IO.puts("server terminated because - #{reason}")
  end

  # CALLBACKS

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_info(msg, stats) do
    IO.puts "received out of bound message - #{msg}"
    {:noreply, stats}
  end

  def handle_call({:location, location}, _from, state) do
    result = url_for(location) |> HTTPoison.get() |> parse_response
    case result do
      {:ok, temp} ->
        {:reply, "#{temp} C", state}
      _ ->
        {:reply, :error, state}
    end
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  # PRIVATE

  defp url_for(location) do
    location = URI.encode(location)
    "api.openweathermap.org/data/2.5/weather?q=#{location}&appid=943a521e014077c40464a3f28c37cb36"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode |> compute_temprature
  end

  defp parse_response(resp) do
    :error
  end

  defp compute_temprature({:ok, json}) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      e ->
        :error
    end
  end
end
