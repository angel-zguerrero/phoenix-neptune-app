defmodule NeptuneApp.Repo.Migrations.CreateCollaborators do
  use Ecto.Migration

  def change do
    create table(:collaborators) do
      add :role, :string

      timestamps()
    end
  end
end
