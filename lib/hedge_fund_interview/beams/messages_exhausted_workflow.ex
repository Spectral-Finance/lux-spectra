defmodule HedgeFundInterview.Beams.MessagesExhaustedWorkflow do
  alias HedgeFundInterview.ErrorSchema
  alias HedgeFundInterview.Prisms.SendMessageCountRequestSignal
  use Lux.Beam,
    name: "Error Handling Workflow",
    description: "A workflow for handling incomint errors",
    input_schema: ErrorSchema,
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:send_message_count_request, SendMessageCountRequestSignal, [])
    end
  end
end
