defmodule MyappWeb.HelloHTML do
  use MyappWeb, :html

  embed_templates "hello_html/*"
end
