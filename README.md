# Axel

Axel is designed to provide a modular layer on top of an
XML document. Search via XPath and map XML nodes to Elixir structs.


## Example

```xml
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
```

```elixir
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

library = Axel.init_node(@xml, Library)
Enum.each(library.books, fn(book) ->
  IO.puts book.name
end)
```
