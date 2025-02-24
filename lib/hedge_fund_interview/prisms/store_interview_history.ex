defmodule HedgeFundInterview.Prisms.StoreInterviewHistory do
  use Lux.Prism
  alias HedgeFundInterview.InterviewMemory

  def handler(input, _ctx) do
    messages = input.payload["interview_history"]

    messages =
      Enum.map(messages, fn m ->
        %{
          sender: m["sender"],
          message: m["message"]
        }
      end)

    InterviewMemory.store_messages(messages)

    {:ok, messages}
  end
end
