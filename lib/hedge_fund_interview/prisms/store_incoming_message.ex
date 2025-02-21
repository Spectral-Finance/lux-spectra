defmodule HedgeFundInterview.Prisms.StoreIncomingMessage do
  use Lux.Prism
  alias HedgeFundInterview.InterviewMemory

  def handler(input, _ctx) do
    InterviewMemory.store_message(input.sender, input.payload["message"])
    {:ok, input}
  end
end
