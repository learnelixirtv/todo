defmodule Todo.Item do
  defstruct id: nil,
            description: nil,
            completed: false

  def new(description) do
    %__MODULE__{
      id: :random.uniform(1_000_000_000),
      description: description
    }
  end
end
