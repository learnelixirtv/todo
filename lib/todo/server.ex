defmodule Todo.Server do
  use Supervisor

  @spec add_list(String.t) :: GenServer.on_start
  def add_list(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  @spec find_list(String.t) :: Todo.List.t
  def find_list(name) do
    Enum.find lists, fn(child) ->
      Todo.List.name(child) == name
    end
  end

  @spec delete_list(Todo.List.t) :: :ok
  def delete_list(list) do
    Supervisor.terminate_child(__MODULE__, list)
  end

  @spec lists :: [Todo.List.t]
  def lists do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  ###
  # Supervisor API
  ###

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Todo.List, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
