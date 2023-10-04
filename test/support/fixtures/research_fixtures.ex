defmodule NeptuneApp.ResearchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NeptuneApp.Research` context.
  """

  @doc """
  Generate a collaborator.
  """
  def collaborator_fixture(attrs \\ %{}) do
    {:ok, collaborator} =
      attrs
      |> Enum.into(%{
        role: "some role"
      })
      |> NeptuneApp.Research.create_collaborator()

    collaborator
  end

  @doc """
  Generate a experiment.
  """
  def experiment_fixture(attrs \\ %{}) do
    {:ok, experiment} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: :in_progress,
        description: "some description",
        results: "some results",
        conclusions: "some conclusions"
      })
      |> NeptuneApp.Research.create_experiment()

    experiment
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> NeptuneApp.Research.create_comment()

    comment
  end

  @doc """
  Generate a scientific_operation.
  """
  def scientific_operation_fixture(attrs \\ %{}) do
    {:ok, scientific_operation} =
      attrs
      |> Enum.into(%{
        type: "some type",
        result: %{},
        parameters: %{},
        remoteId: "some remoteId",
        remoteStatus: "some remoteStatus",
        remoteResult: %{}
      })
      |> NeptuneApp.Research.create_scientific_operation()

    scientific_operation
  end

  @doc """
  Generate a ingestion.
  """
  def ingestion_fixture(attrs \\ %{}) do
    {:ok, ingestion} =
      attrs
      |> Enum.into(%{
        code: "some code",
        lastDate: ~T[14:00:00]
      })
      |> NeptuneApp.Research.create_ingestion()

    ingestion
  end
end
