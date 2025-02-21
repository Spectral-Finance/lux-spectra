defmodule HedgeFundInterview.Schemas.ErrorSchema do
  @moduledoc """
  The error schema represents an error in the business logic of the Hedge Fund.

  Will be used to tell other agents that while the signal was well-formed, Spectra CEO could not process it, due to either a business/environment constraint (ie. insufficient funds), a misunderstanding in the contents of the signal or an internal server or LLM error.
  """

  @id "d6f9b8e2-2b3a-6e3a-af3a-2b3a6e3aaf3a"

  use Lux.SignalSchema,
    name: "error",
    schema: %{
      type: "object",
      properties: %{
        reason: %{type: "string"},
        type: %{type: "string"},
        failed_signal_id: %{type: "string"}
      },
      required: ["reason", "type", "failed_signal_id"]
    },
    description: "Represents an error coming from an agent in the Hedge Fund",
    version: "1.0.0",
    tags: ["error"],
    compatibility: "full",
    status: "active",
    format: "json"

  def signal_schema_id, do: @id
end
