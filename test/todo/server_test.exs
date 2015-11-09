defmodule Todo.ServerTest do
  use ExUnit.Case

  alias Todo.Server

  setup do
    on_exit fn ->
      Enum.each Server.lists, fn(list) ->
        Server.delete_list(list)
      end
    end
  end

  test ".add_list adds a new supervised todo list" do
    Server.add_list("Home")
    Server.add_list("Work")

    counts = Supervisor.count_children(Server)

    assert counts.active == 2
  end

  test ".find_list gets a list by its name" do
    Server.add_list("find-by-name")
    list = Server.find_list("find-by-name")

    assert is_pid(list)
  end

  test ".delete_list deletes a list by its name" do
    Server.add_list("delete-me")
    list = Server.find_list("delete-me")

    Server.delete_list(list)
    counts = Supervisor.count_children(Server)

    assert counts.active == 0
  end
end
