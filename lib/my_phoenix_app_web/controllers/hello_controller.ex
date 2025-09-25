defmodule MyPhoenixAppWeb.HelloController do
  use MyPhoenixAppWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def show(conn, %{"messanger" => messanger}) do
    render(conn, :show, messanger: messanger)
  end
end
