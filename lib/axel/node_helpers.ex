defmodule Axel.NodeHelpers do
  import Axel

  @doc """
  Returns the text value of an XML element at `path`, or `nil`
  if no element was found.

  ## Examples

    iex> Axel.parse("<name>Lee</name>") |> Axel.NodeHelpers.field("//name")
    "Lee"

  """
  def field(node, path) do
    case find(node, path) do
      nil -> nil
      value -> text(value)
    end
  end

  @doc """
  Returns a list of node results, after calling `init_node`
  on `module`.

  If no results were found, an empty list will be returned.

  If `module` does not implement `init_node/1`, an exception
  will be raised.

  ## Examples

    defmodule MyApp.Book do
      defstruct [:name]

      def init_node(node) do
        %MyApp.Book{name: field(node, "./name")}
      end
    end

    Axel.NodeHelpers.collection(doc, "//books", MyApp.Book)
    |> Enum.each(fn(book) -> IO.puts(book.name) end)

  """
  def collection(node, path, module) do
    search(node, path)
    |> Enum.map(&module.init_node/1)
  end
end
