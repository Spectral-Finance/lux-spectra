defmodule HedgeFundInterview.Schemas.RejectMessageSchema do
  @moduledoc """
  The Lux schema for the reject messages of a company.
  """

  @id "c44fcb27-3d4c-4241-bcff-14880ffb7896"

  use Lux.SignalSchema,
    name: "reject_message",
    schema: %{
      type: "object",
      properties: %{
        message: %{type: "string"},
        job_opening_id: %{type: "string"}
      },
      required: ["message", "job_opening_id"]
    },
    description:
      "Represents the a message of rejection from an interview. If received, the agent should stop sending messages as they will not be processed further.",
    version: "1.0.0",
    tags: ["interview", "hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
