defmodule HedgeFundInterview.Schemas.MessagesCountRequestSchema do
  @moduledoc """
  The Lux schema to request the messages count of the agent.
  """

  @id "38b001fa-0cb4-44f4-ab99-c9493fcd5218"

  use Lux.SignalSchema,
    name: "message_count_request",
    schema: %{
      type: "object",
      properties: %{},
      required: []
    },
    description: "Represents the agent asking for its message count",
    version: "1.0.0",
    tags: ["hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
