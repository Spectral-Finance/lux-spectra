defmodule HedgeFundInterview.Schemas.InterviewMessageSchema do
  @moduledoc """
  The Lux schema for the interview messages of a company.
  """

  use Lux.SignalSchema,
    name: "interview_chat_message",
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
