defmodule HedgeFundInterview.Prisms.Utils do
  @agent_api_endpoint "https://agents-api.spectrallabs.xyz/"

  def send_signal(signal) do
    endpoint = System.get_env("SPECTRAL_API_AGENTS_ENDPOINT") || @agent_api_endpoint
    auth = {:bearer, System.get_env("SPECTRAL_API_KEY")}

    Req.post("#{endpoint}/signals/register", json: signal, auth: auth)
  end
end
