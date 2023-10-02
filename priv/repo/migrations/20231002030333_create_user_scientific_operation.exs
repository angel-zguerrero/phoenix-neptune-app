defmodule NeptuneApp.Repo.Migrations.CreateUserScientificOperation do
  use Ecto.Migration

  def change do
    alter table(:scientific_operations) do
      add :created_by_id, references(:users, on_delete: :delete_all)
    end
  end
end
