defmodule NeptuneApp.Repo.CreateDatabase do
  import Postgrex


  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :neptune_app

  defp ensure_repo_created(repo) do
    IO.puts "create #{inspect repo} database if it doesn't exist"
    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end

  def migrate do
    IO.inspect("CREATING DATABASE!!!!")
    load_app()
    for repo <- repos() do
      result = ensure_repo_created(repo)
      IO.inspect("---> result <---")
      IO.inspect(result)
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
