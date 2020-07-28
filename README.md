# Metex

**Simple project that demonstrates usage of OTP GenServer in elixir**

## How to play

- Load Metex Worker in the console `iex -S mix`
- Start a metex GenServer `iex(2)> Metex.Worker.start_link()`
- Fetch temprature `iex(2)> Metex.Worker.get_temprature "mumbai"`
- Stop GenServer `iex(2)> Metex.Worker.stop()`



