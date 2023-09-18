defmodule ChatWeb.ProfileController do
  use ChatWeb, :controller

  def profile(conn, _params) do
    render(conn, :profile)
  end
end
