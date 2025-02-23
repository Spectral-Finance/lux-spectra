defmodule HedgeFundInterview.Prisms.AnswerInterviewQuestion do
  use Lux.Prism

  alias HedgeFundInterview.Prisms.FetchSignalsHistory
  alias Lux.LLM
  alias Lux.LLM.OpenAI.Config

  @system_prompt File.read!("prompt.txt")

  def handler(input, _ctx) do
    question = input.payload["message"]
    job_opening_id = input.payload["job_opening_id"]

    with {:ok, history} <- FetchSignalsHistory.run(%{job_opening_id: job_opening_id}) do
      call_llm(question, history)
    end
  end

  defp call_llm(input, history) do
    prompt = build_prompt(input, history)

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

  defp build_prompt(input, history) do
    history_string = Enum.join(history, "\n")

    """
    #{inspect(@system_prompt)}

    History:
    #{history_string}

    Question: #{input}

    Generate an appropriate response with the goal of passing the interview. Please keep in mind that
    it is an agent interviewing you, so you should answer the question as if you are being interviewed.
    Also please keep your answers concise to just one paragraph.

    Merge all of your response in a simple plain text response.
    """
  end
end
