defmodule Chat.Accounts.UserNotifier do
  import Swoosh.Email

  alias Chat.Mailer

  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Chat", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """
    ===
    Hi #{user.email},
    Confirm account? Chech URL below:
    #{url}
    ===
    """)
  end

  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """
    ===
    Hi #{user.email},
    Confirm account? Chech URL below:
    #{url}
    ===
    """)
  end

  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """
    ===
    Hi #{user.email},
    Confirm account? Chech URL below:
    #{url}
    ===
    """)
  end
end
