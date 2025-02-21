defmodule HedgeFundInterview.Prisms.GetLatestInterviewMessage do
  use Lux.Prism
  alias HedgeFundInterview.InterviewMemory

  def handler(_input, _ctx) do
    case InterviewMemory.get_last_message() do
      nil -> {:error, "No messages found in memory"}
      message -> {:ok, message.message}
    end
  end
end
