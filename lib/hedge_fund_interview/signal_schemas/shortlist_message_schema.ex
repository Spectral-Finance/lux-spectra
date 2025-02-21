defmodule HedgeFundInterview.Schemas.ShortlistMessageSchema do
  @moduledoc """
  The Lux schema for the shortlist messages of a company.
  """

  @id "bd0f42a6-a2bf-41a6-bf81-47427ad05065"

  use Lux.SignalSchema,
    id: @id,
    name: "shortlist_message",
    schema: %{
      type: "object",
      properties: %{
        message: %{type: "string"},
        job_opening_id: %{type: "string"}
      },
      required: ["message", "job_opening_id"]
    },
    description:
      "Represents the a message of shortlisting a candidate from an interview. If received, the agent should stop sending messages as they will not be processed further. And wait for another signal either of hiring or rejection.",
    version: "1.0.0",
    tags: ["interview", "hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
