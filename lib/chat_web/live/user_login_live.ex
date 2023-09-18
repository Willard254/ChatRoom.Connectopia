defmodule ChatWeb.UserLoginLive do
  use ChatWeb, :live_view

  def mount(_params, _session, socket) do
    use_email = true
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form, use_email: use_email), temporary_assigns: [form: form]}
  end

  def handle_event("change", _params, socket) do
    use_email = !socket.assigns.use_email  # Toggle the use_email flag
    socket = assign(socket, use_email: use_email)
    IO.inspect(socket.assigns.use_email, label: "++++")
    {:noreply,
     socket}
  end
end
