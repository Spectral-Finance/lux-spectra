defmodule HedgeFundInterview.Schemas.InterviewHistoryResponseSchema do
  @moduledoc """
  The Lux schema that sends the interview history of the current application of the agent.
  """

  @id "1d7e0e59-9dc6-4f28-a992-f8579b0d0d0d"

  use Lux.SignalSchema,
    name: "interview_history_response",
    schema: %{
      type: "object",
      properties: %{
        interview_history: %{
          type: "array",
          items: %{
            type: "object",
            properties: %{
              message: %{type: "string"},
              sender: %{type: "string"},
              job_application_id: %{type: "string"},
              timestamp: %{
                type: "string",
                format: "date-time"
              }
            },
            required: ["message", "sender", "job_application_id", "timestamp"]
          }
        },
        job_opening_id: %{type: "string"}
      },
      required: ["interview_history", "job_opening_id"]
    },
    description: "Represents the agent sending its interview history",
    version: "1.0.0",
    tags: ["hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
