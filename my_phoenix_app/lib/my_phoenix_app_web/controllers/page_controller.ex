defmodule MyPhoenixAppWeb.PageController do
  use MyPhoenixAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
