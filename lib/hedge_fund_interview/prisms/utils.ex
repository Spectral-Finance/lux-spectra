defmodule HedgeFundInterview.Prisms.Utils do
  def send_signal(signal) do
    endpoint = System.get_env("SPECTRAL_API_AGENTS_ENDPOINT")

    case Req.post("#{endpoint}/signals/register", json: signal) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
  end
end
