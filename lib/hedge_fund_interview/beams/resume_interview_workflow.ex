defmodule HedgeFundInterview.Beams.ResumeInterviewWorkflow do
  alias HedgeFundInterview.InterviewMessageSchema
  alias HedgeFundInterview.Prisms.GetLatestInterviewMessage
  alias HedgeFundInterview.Prisms.SendResponseSignal

  use Lux.Beam,
    name: "Resume Interview Workflow",
    description: "A workflow for resuming an interview by resending the last message",
    input_schema: InterviewMessageSchema,
    output_schema: InterviewMessageSchema,
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:get_last_message, GetLatestInterviewMessage, [:input])
      step(:send_response, SendResponseSignal, [:steps, :get_last_message, :result])
    end
  end
end
