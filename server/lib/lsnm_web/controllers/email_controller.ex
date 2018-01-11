defmodule LsnmWeb.Mailer do
  use Bamboo.Mailer, otp_app: :lsnm
end

defmodule LsnmWeb.EmailController do
  use LsnmWeb, :controller
  import Bamboo.Email
  alias LsnmWeb.Mailer

  def welcome_email do
    # or pipe using Bamboo.Email functions
    new_email
    |> to("nickstalter@gmail.com")
    |> from("me@example.com")
    |> subject("Welcome!!!")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
    |> Mailer.deliver_now
  end

  def feedback(conn, params) do
    new_email
    |> to("nickstalter@gmail.com")
    |> from("feedback@lunchspecialsnearme.com")
    |> subject("Feedback!!!")
    |> html_body("<strong>#{params["feedback"]}</strong>")
    |> text_body(params["feedback"])
    |> Mailer.deliver_now
    json(conn, %{:body => %{"status" => "ok"}})
  end
end

