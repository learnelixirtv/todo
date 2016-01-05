defmodule Todo.Cache do
  use GenServer

  import String, only: [to_atom: 1]

  @spec save(Todo.List.state) :: boolean
  def save(list) do
    :ets.insert(__MODULE__, {to_atom(list.name), list})
  end

  @spec find(String.t) :: Todo.List.state | nil
  def find(list_name) do
    case :ets.lookup(__MODULE__, to_atom(list_name)) do
      [{_id, value}] -> value
      [] -> nil
    end
  end

  @spec clear :: boolean
  def clear do
    :ets.delete_all_objects(__MODULE__)
  end

  ###
  # GenServer API
  ###

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    table = :ets.new(__MODULE__, [:named_table, :public])
    {:ok, table}
  end
end
