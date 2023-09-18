defmodule Chat.Repo.Migrations.AddNewFieldsToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone_number, :string, unique: true
    end
  end
end
