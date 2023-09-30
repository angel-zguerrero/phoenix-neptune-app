defmodule NeptuneApp.Repo.Migrations.CreateUserExperiment do
  use Ecto.Migration

  def change do

    alter table(:experiments) do
      add :created_by_id, references(:users, on_delete: :delete_all)
    end

  end
end
