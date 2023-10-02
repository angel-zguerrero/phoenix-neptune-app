defmodule NeptuneApp.Repo.Migrations.CreateExperimentScientificOperation do
  use Ecto.Migration

  def change do
    alter table(:scientific_operations) do
      add :experiment_id, references(:experiments, on_delete: :delete_all)
    end
  end
end
