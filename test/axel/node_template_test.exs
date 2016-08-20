defmodule Axel.NodeTemplateTest do
  use ExUnit.Case
  doctest Axel.NodeTemplate

  @xml """
    <library>
      <book>
        <author id="123">Lee Jarvis</author>
        <name>Lorem ipsum</name>
      </book>
      <book>
        <author id="456">John Smith</author>
        <name>Foo bar</name>
      </book>
    </library>
  """

  defmodule Book do
    use Axel.NodeTemplate

    defstruct [:name, :author]

    def init_node(node) do
      %Book{
        name: field(node, "name"),
        author: field(node, "author")
      }
    end
  end

  defmodule Library do
    use Axel.NodeTemplate

    defstruct [:books]

    def init_node(node) do
      %Library{
        books: collection(node, "//book", Book)
      }
    end
  end

  test "node templates" do
    library = Axel.init_node(@xml, Library)

    assert 2 == Enum.count(library.books)
    assert "Lorem ipsum" == hd(library.books).name
  end
end
