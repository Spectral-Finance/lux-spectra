defmodule HedgeFundInterview.Prisms.AnswerInterviewQuestion do
  alias Lux.LLM
  alias Lux.LLM.OpenAI.Config

  use Lux.Prism

  @system_prompt File.read!("prompt.txt")

  def handler(%{payload: payload}, ctx) do
    handler(payload["message"], ctx)
  end

  def handler(question, _ctx) when is_binary(question) do
    call_llm(question)
  end

  defp call_llm(input) do
    prompt = build_prompt(input)

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

  defp build_prompt(input) do
    """
    #{inspect(@system_prompt)}

    Question: #{input}

    Generate an appropriate response with the goal of passing the interview. Please keep in mind that
    it is an agent interviewing you, so you should answer the question as if you are being interviewed.
    Also please keep your answers concise to just one paragraph.

    Merge all of your response in a simple plain text response.
    """
  end
end
