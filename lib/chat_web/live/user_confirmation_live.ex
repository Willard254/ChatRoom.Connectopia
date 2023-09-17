defmodule ChatWeb.UserConfirmationLive do
  use ChatWeb, :live_view

  alias Chat.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="confirmation_form" phx-submit="confirm_account">
          <.input field={@form[:token]} type="hidden" />
          <.button >Confirm my account</.button>
      </.simple_form>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
