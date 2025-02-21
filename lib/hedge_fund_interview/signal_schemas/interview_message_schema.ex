defmodule HedgeFundInterview.Schemas.InterviewMessageSchema do
  @moduledoc """
  The Lux schema for the interview messages of a company.
  """

  @id "c5f8b7e1-1b2a-5e2a-9f2a-1b2a5e2a9f2a"

  use Lux.SignalSchema,
    name: "interview_chat_message",
    id: @id,
    schema: %{
      type: "object",
      properties: %{
        message: %{type: "string"},
        job_opening_id: %{type: "string"}
      },
      required: ["message", "job_opening_id"]
    },
    description: "Represents the chat message of an interview between a candidate and a company",
    version: "1.0.0",
    tags: ["interview", "hedge_fund"],
    compatibility: "full",
    status: "active",
    format: "json"
end
