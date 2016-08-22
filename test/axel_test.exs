defmodule AxelTest do
  use ExUnit.Case
  doctest Axel

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

  setup do
    {:ok, %{doc: Axel.parse(@xml) }}
  end

  test "parsing XML", %{doc: doc} do
    assert is_tuple(doc)
  end

  test "basic searching", %{doc: doc} do
    names = doc
    |> Axel.search("//author")
    |> Enum.map(&Axel.text/1)
    assert ["Lee Jarvis", "John Smith"] == names

    names = doc
    |> Axel.search("//author[@id='123']/../name")
    |> Enum.map(&Axel.text/1)
    assert ["Lorem ipsum"] == names
  end

  test "finding the first occurence", %{doc: doc} do
    assert "Lorem ipsum" == Axel.find(doc, "//book/name") |> Axel.text
    assert nil == Axel.find(doc, "foo/bar")
  end

  test "extracting attributes", %{doc: doc} do
    author = Axel.find(doc, "//author")
    assert "123" == Axel.attribute(author, "id")
    assert nil == Axel.attribute(author, "foo")
  end
end
