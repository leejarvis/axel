defmodule Axel do
  require Record
  Record.defrecord :xmlElement,   Record.extract(:xmlElement,   from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,      Record.extract(:xmlText,      from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  def parse(xml) do
    {doc, []} = xml
    |> :binary.bin_to_list
    |> :xmerl_scan.string
    doc
  end

  def search(node, xpath) do
    :xmerl_xpath.string(to_char_list(xpath), node)
  end

  def find(node, xpath) do
    case search(node, xpath) do
      [h | _] -> h
      [] -> nil
    end
  end

  def text(node) do
    case find(node, "./text()") do
      xmlText(value: value) -> List.to_string(value)
      _ -> nil
    end
  end

  def attribute(node, attr_name) do
    case find(node, "./@#{attr_name}") do
      xmlAttribute(value: value) -> List.to_string(value)
      _ -> nil
    end
  end
end
