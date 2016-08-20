defmodule Axel.NodeTemplate do
  defmacro __using__(_) do
    quote do
      import Axel
      import Axel.NodeHelpers
    end
  end
end
