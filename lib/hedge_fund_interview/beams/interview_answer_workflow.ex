defmodule HedgeFundInterview.Beams.InterviewAnswerWorkflow do
  alias HedgeFundInterview.InterviewMessageSchema
  alias HedgeFundInterview.Prisms.AnswerInterviewQuestion
  alias HedgeFundInterview.Prisms.SendResponseSignal
  alias HedgeFundInterview.Prisms.StoreIncomingMessage
  alias HedgeFundInterview.Prisms.StoreOutgoingMessage

  use Lux.Beam,
    name: "Interview Answer Workflow",
    description: "A workflow for answering interview questions",
    input_schema: InterviewMessageSchema,
    output_schema: InterviewMessageSchema,
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:store_incoming, StoreIncomingMessage, [:input])
      step(:answer, AnswerInterviewQuestion, [:input])
      step(:store_outgoing, StoreOutgoingMessage, [:steps, :answer, :result])
      step(:send_response, SendResponseSignal, [:steps, :answer, :result])
    end
  end
end
