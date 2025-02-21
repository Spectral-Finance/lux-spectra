defmodule HedgeFundInterview.Prisms.StoreOutgoingMessage do
  use Lux.Prism
  alias HedgeFundInterview.InterviewMemory

  def handler(answer, _ctx) do
    InterviewMemory.store_message(System.get_env("ANS_HANDLE"), answer)
    {:ok, answer}
  end
end
