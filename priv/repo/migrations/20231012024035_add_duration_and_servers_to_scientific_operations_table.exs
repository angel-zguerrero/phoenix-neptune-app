defmodule NeptuneApp.Repo.Migrations.AddDurationAndServersToScientificOperationsTable do
  use Ecto.Migration

  def change do
    alter table(:scientific_operations) do
      add :duration, :float, after: :email, null: true
      add :servers, :string, size: 500, after: :email, null: true
    end
  end
end
