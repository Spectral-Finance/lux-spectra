defmodule HedgeFundInterview.Beams.BeginInterview do
  alias HedgeFundInterview.Prisms.RequestInterviewHistory
  alias HedgeFundInterview.Prisms.RegisterAgentSignal

  use Lux.Beam,
    name: "Begin Interview",
    description: "A workflow for beginning an interview",
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:register_agent, RegisterAgentSignal, [:input])
      step(:request_interview_history, RequestInterviewHistory, [:input])
    end
  end
end
