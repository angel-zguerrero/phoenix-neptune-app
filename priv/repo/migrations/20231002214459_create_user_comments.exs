defmodule NeptuneApp.Repo.Migrations.CreateUserComments do
  use Ecto.Migration

  def change do

    alter table(:comments) do
      add :created_by_id, references(:users, on_delete: :delete_all)
    end

  end
end
