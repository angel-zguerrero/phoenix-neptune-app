defmodule NeptuneApp.Repo.Migrations.AddRoleToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, size: 10, after: :email, null: false
    end
  end
end
