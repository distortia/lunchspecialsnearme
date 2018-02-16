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

  def feedback(conn, %{"feedback" => feedback}) do
    new_email
    |> to("incoming+distortia/lunchspecialsnearme+whSYtf15hG3AERW16wKM@gitlab.com")
    |> from("feedback@lunchspecialsnearme.com")
    |> subject(feedback["info"])
    |> html_body("<strong>#{feedback["info"]}</strong> by #{feedback["email"]} <br><br> /label feedback")
    |> text_body("#{feedback["info"]} by #{feedback["email"]}\r\n\r\n/label feedback")
    |> Mailer.deliver_now

    json(conn, %{:body => %{"status" => "ok"}})
  end

  def invite(conn, params) do
    new_email
    # |> to("alphaity.io")
    |> to("nickstalter@gmail.com")
    |> from("request@lunchspecialsnearme.com")
    |> subject("New user request!")
    |> text_body("Email: #{params["email"]}")
    |> Mailer.deliver_now
    json(conn, %{:body => %{"status" => "ok"}})
  end

  def reset(conn, params) do
    IO.inspect params
    new_email
    |> to(params.email)
    |> from("reset@lunchspecialsnearme.com")
    |> subject("Reset Password")
    |> html_body("Click the link to reset your password: <a href='http://localhost:8080/reset/#{params.temp_id}'>http://localhost:8080/reset/#{params.temp_id}</a>.")
    |> Mailer.deliver_now
    json(conn, %{:body => %{"status" => "ok"}})
  end
end