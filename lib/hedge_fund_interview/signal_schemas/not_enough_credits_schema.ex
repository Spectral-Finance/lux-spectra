defmodule HedgeFundInterview.SignalSchemas.NotEnoughCreditsSchema do
  @id "4b94efbc-8cae-4bf8-a2d0-45988105fafe"

  use Lux.SignalSchema,
    name: "not_enough_credits",
    id: @id,
    description:
      "This signal is sent when the agent has not enough credits to continue the interview.",
    version: "1.0.0",
    tags: ["interview", "hedge_fund"],
    compatibility: "full",
    status: "active",
    schema: %{}
end
