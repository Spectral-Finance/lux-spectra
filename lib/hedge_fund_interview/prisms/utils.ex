defmodule HedgeFundInterview.Prisms.Utils do
  def send_signal(signal) do
    endpoint = System.get_env("SPECTRAL_API_AGENTS_ENDPOINT")
    api_key = System.get_env("SPECTRAL_API_KEY")

    case Req.post("#{endpoint}/signals/register",
           json: signal,
           headers: [{"authorization", "Bearer #{api_key}"}]
         ) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
  end
end
