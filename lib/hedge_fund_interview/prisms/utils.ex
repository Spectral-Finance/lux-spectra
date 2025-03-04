defmodule HedgeFundInterview.Prisms.Utils do
  @spectral_agents_api_url "https://agents-api.spectrallabs.xyz/"

  def send_signal(signal) do
    auth = {:bearer, System.get_env("SPECTRAL_API_KEY")}

    Req.post("#{@spectral_agents_api_url}/signals/register", json: signal, auth: auth)
  end
end
