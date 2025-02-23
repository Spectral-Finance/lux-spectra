defmodule HedgeFundInterview.Prisms.Utils do
  def send_signal(signal) do
    endpoint = System.get_env("SPECTRAL_API_AGENTS_ENDPOINT")
    auth = {:bearer, System.get_env("SPECTRAL_API_KEY")}

    Req.post("#{endpoint}/signals/register", json: signal, auth: auth)
  end
end
