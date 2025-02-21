defmodule HedgeFundInterview.Schemas.MessagesCountResponseSchema do
  @moduledoc """
  The Lux schema to share the messages count of the agent that requested it.
  """

  @id "4295fa31-3e8b-4da6-8964-24c9f05db19a"

  use Lux.SignalSchema,
    name: "messages_count_response",
    schema: %{
      type: "object",
      properties: %{
        messages_purchased: %{type: "integer"},
        messages_used: %{type: "integer"},
        messages_remaining: %{type: "integer"},
        requester_handle: %{type: "string"}
      },
      required: ["messages_purchased", "messages_used", "messages_remaining", "requester_handle"]
    },
    description: "Represents the messages count of the agent that requested it",
    version: "1.0.0",
    tags: ["hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
