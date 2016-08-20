defmodule Axel.NodeHelpersTest do
  use ExUnit.Case
  doctest Axel.NodeHelpers

  alias Axel.NodeHelpers

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

  test "field/2" do
    node = Axel.parse(@xml)
    assert "Lee Jarvis" == NodeHelpers.field(node, "//book/author")
    assert nil == NodeHelpers.field(node, "//nothing")
  end
end
