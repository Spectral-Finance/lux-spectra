defmodule HedgeFundInterview.Beams.InterviewHistoryWorkflow do
  alias HedgeFundInterview.Schemas.InterviewHistoryResponseSchema
  alias HedgeFundInterview.Prisms.AnswerInterviewQuestion
  alias HedgeFundInterview.Prisms.GetLatestInterviewMessage
  alias HedgeFundInterview.Prisms.SendResponseSignal
  alias HedgeFundInterview.Prisms.StoreInterviewHistory
  alias HedgeFundInterview.Prisms.StoreOutgoingMessage

  use Lux.Beam,
    name: "Interview History Workflow",
    description: "A workflow for processing interview history responses and continuing the interview",
    input_schema: InterviewHistoryResponseSchema,
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:store_history, StoreInterviewHistory, [:input])
      step(:get_last_message, GetLatestInterviewMessage, [:input])
      step(:answer, AnswerInterviewQuestion, [:steps, :get_last_message, :result])
      step(:store_outgoing, StoreOutgoingMessage, [:steps, :answer, :result])
      step(:send_response, SendResponseSignal, [:steps, :answer, :result])
    end
  end
end
