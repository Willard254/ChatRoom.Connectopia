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
    case Map.fetch(user_params, "email") do
      {:ok, email} when is_binary(email) ->
        password = user_params["password"]
        handle_auth(conn, email, password, info)

      :error ->
        case Map.fetch(user_params, "phone_number") do
          {:ok, phone_number} when is_binary(phone_number) ->
            password = user_params["password"]
            handle_auth(conn, phone_number, password, info)

          :error ->
            conn
            |> put_flash(:error, "Email or Phone Number is required.")
            |> redirect(to: ~p"/users/log_in")
        end
    end
  end

  defp handle_auth(conn, identifier, password, info) do
    case Accounts.get_user_by_email_or_phone_and_password(identifier, password) do
      nil ->
        conn
        |> put_flash(:error, "Wrong email, phone number, or password! :(")
        |> redirect(to: ~p"/users/log_in")

      user ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, %{"user" => %{"password" => password}})
    end
  end

  # defp create(conn, %{"user" => user_params}, info) do
  #   %{"phone_number" => phone_number, "password" => password} = user_params

  #   if user = Accounts.get_user_by_phone_number_and_password(phone_number, password) do
  #     conn
  #     |> put_flash(:info, info)
  #     |> UserAuth.log_in_user(user, user_params)
  #   else
  #     conn
  #     |> put_flash(:error, "Wrong phone number or password! :(")
  #     |> put_flash(:phone_number, String.slice(phone_number, 0, 160))
  #     |> redirect(to: ~p"/users/log_in")
  #   end
  # end

  # defp create(conn, %{"user" => user_params}, info) do
  #   %{"email" => email, "phone_number" => phone_number, "password" => password} = user_params

  #   user =
  #     case {email, phone_number} do
  #       {nil, _} ->
  #         Accounts.get_user_by_uniqueness_and_password(phone_number, password)

  #       {_, nil} ->
  #         Accounts.get_user_by_uniqueness_and_password(email, password)
  #     end

  #   case user do
  #     nil ->
  #       conn
  #       |> put_flash(:error, "Wrong email or phone number or password!")
  #       |> redirect(to: "/users/log_in")

  #     _ ->
  #       conn
  #       |> put_flash(:info, info)
  #       |> UserAuth.log_in_user(user, user_params)
  #   end
  # end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Loggged Out. See you soon!!")
    |> UserAuth.log_out_user()
  end
end
