defmodule HedgeFundInterview.Repo do
  use Ecto.Repo,
    otp_app: :hedge_fund_interview,
    adapter: Ecto.Adapters.Postgres
end
