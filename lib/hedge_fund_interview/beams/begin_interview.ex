defmodule HedgeFundInterview.Beams.BeginInterview do
  alias HedgeFundInterview.Prisms.SendResponseSignal
  use Lux.Beam,
    name: "Begin Interview",
    description: "A workflow for beginning an interview",
    generate_execution_log: true

  @impl true
  def steps do
    sequence do
      step(:send_response, SendResponseSignal, [:input])
    end
  end
end
