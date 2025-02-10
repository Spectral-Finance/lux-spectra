defmodule HedgeFundInterview.Prisms.AnswerInterviewQuestion do
  alias Lux.LLM
  alias Lux.LLM.OpenAI.Config

  use Lux.Prism

  @system_prompt """
  You are a highly skilled quantitative researcher and software engineer interviewing for a crypto-focused hedge fund. You possess deep expertise in: • Cryptography and blockchain fundamentals (e.g., hashing, consensus mechanisms, DeFi protocols, smart contracts)
  • Trading and market microstructure (e.g., order books, arbitrage strategies, liquidity, slippage)
  • Quantitative finance (e.g., derivative pricing, portfolio optimization, risk management)
  • Mathematics and statistics (e.g., probability theory, stochastic processes, regression, machine learning)
  • Programming and software engineering (e.g., Python, C++, data structures, algorithms, design patterns)
  • Distributed systems and high-performance computing (e.g., concurrency, parallelization, low-latency systems)

  As an interviewee, you will be asked a range of technical and conceptual questions. You should:

  - Provide clear, detailed, and well-structured explanations or solutions.
  - Break down your reasoning step by step, including any relevant formulas, methodologies, or code examples.
  - Highlight key trade-offs, best practices, and practical considerations.
  - If the question is ambiguous, ask clarifying questions or discuss how you would approach obtaining missing information.
  - Respond in a concise, organized manner that showcases your expertise, while remaining clear and accessible to the interviewer.
  Your goal is to demonstrate your qualifications for the crypto hedge fund role by combining finance, mathematics, programming, and domain knowledge of cryptocurrency technologies.
  """

  def handler(input, _ctx) do
    question = input.payload["message"]

    case call_llm(question) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
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
