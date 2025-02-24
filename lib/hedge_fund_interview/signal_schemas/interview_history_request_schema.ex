defmodule HedgeFundInterview.Schemas.InterviewHistoryRequestSchema do
  @moduledoc """
  The Lux schema to request the interview history of the agent.
  """

  @id "87d96f41-0414-475f-9240-ce67b90d390e"

  use Lux.SignalSchema,
    name: "interview_history_request",
    schema: %{
      type: "object",
      properties: %{
        job_opening_id: %{type: "string"}
      },
      required: ["job_opening_id"]
    },
    description: "Represents the agent asking for its interview history",
    version: "1.0.0",
    tags: ["hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
