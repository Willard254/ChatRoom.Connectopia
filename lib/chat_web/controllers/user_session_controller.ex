defmodule ChatWeb.UserSessionController do
  use ChatWeb, :controller

  alias Chat.Accounts
  alias ChatWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Success on creating Account :)")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      conn
      |> put_flash(:error, "Wrong email or password! :(")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Loggged Out. See you soon!!")
    |> UserAuth.log_out_user()
  end
end
