defmodule ChatWeb.UserForgotPasswordLive do
  use ChatWeb, :live_view

  alias Chat.Accounts

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <.button>Send password reset instructions</.button>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
        "If your email is in our system, you will receive instructions to reset your password shortly."

      {:noreply,
      socket
      |> put_flash(:info, info)
      |> redirect(to: ~p"/")}
  end
end
