defmodule HedgeFundInterview.Prisms.AnswerInterviewQuestion do
  alias Lux.LLM
  alias Lux.LLM.OpenAI.Config

  use Lux.Prism

  @system_prompt File.read!("prompt.txt")

  def handler(%{payload: payload}, ctx) do
    handler(payload["message"], ctx)
  end

  def handler(question, _ctx) when is_binary(question) do
    past_messages = HedgeFundInterview.InterviewMemory.get_all_messages()
    call_llm(question, past_messages)
  end

  defp call_llm(input, past_messages) do
    prompt = build_prompt(input, past_messages) |> IO.inspect(label: "PROMPT")

    llm_config = %Config{
      api_key: System.get_env("OPENAI_API_KEY"),
      model: "gpt-4o",
      temperature: 0.2
    }

    case LLM.call(prompt, [], llm_config) do
      {:ok, response_signal} -> {:ok, response_signal.payload.content["response"]}
      {:error, error} -> {:error, error}
    end
  rescue
    error ->
      {:error, error}
  end

  defp build_prompt(input, past_messages) do
    conversation_history =
      Enum.map_join(past_messages, "\n", fn %{sender: sender, message: message} ->
        "#{sender}: #{message}"
      end)

    """
    #{inspect(@system_prompt)}

    Previous conversation:
    #{conversation_history}

    Question: #{input}

    Generate an appropriate response with the goal of passing the interview. Please keep in mind that
    it is an agent interviewing you, so you should answer the question as if you are being interviewed.
    Also please keep your answers concise to just one paragraph.

    Merge all of your response in a simple plain text response.
    """
  end
end
