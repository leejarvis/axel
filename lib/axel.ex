defmodule Axel do
  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  @doc """
  Parses an XML string.
  """
  def parse(xml) do
    {doc, []} = xml
    |> :binary.bin_to_list
    |> :xmerl_scan.string
    doc
  end

  @doc """
  Returns a list of elements from an XPath search.

  ## Examples

    Axel.parse("<div>one</div><div>two</div>") |> Axel.search("//div")
  """
  def search(node, xpath) do
    :xmerl_xpath.string(to_char_list(xpath), node)
  end

  @doc """
  Returns the first result in an XPath search. `nil` will be returned
  if the search returned no results.

  ## Examples

    Axel.parse("<div>Hello</div>") |> Axel.find("//div")
  """
  def find(node, xpath) do
    case search(node, xpath) do
      [h | _] -> h
      [] -> nil
    end
  end

  @doc """
  Returns the text for this node.

  ## Examples

    iex> Axel.parse("<div>Hello</div>") |> Axel.text
    "Hello"
  """
  def text(node) do
    case find(node, "./text()") do
      xmlText(value: value) -> List.to_string(value)
      _ -> nil
    end
  end

  @doc """
  Returns the attribute for this node, or `nil` if it does not exist.

  ## Examples

    iex> Axel.parse("<div id='123'></div>") |> Axel.attribute("id")
    "123"
  """
  def attribute(node, attr_name) do
    case find(node, "./@#{attr_name}") do
      xmlAttribute(value: value) -> List.to_string(value)
      _ -> nil
    end
  end
end
