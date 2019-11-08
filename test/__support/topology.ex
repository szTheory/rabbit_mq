defmodule MQTest.Support.Topology do
  alias MQ.Topology

  @exchanges ~w(airline_request audit_log service_request)

  @behaviour Topology

  def gen do
    @exchanges |> Enum.map(&exchange/1)
  end

  defp exchange("airline_request" = exchange) do
    {exchange,
     type: :topic,
     durable: true,
     routing_keys: [
       {"*.place_booking",
        queue: "#{exchange}_queue/*.place_booking/bookings_app",
        durable: true,
        dlq: "#{exchange}_dead_letter_queue"},
       {"*.cancel_booking",
        queue: "#{exchange}_queue/*.cancel_booking/bookings_app",
        durable: true,
        dlq: "#{exchange}_dead_letter_queue"}
     ]}
  end

  defp exchange("audit_log" = exchange) do
    {exchange,
     type: :topic,
     durable: true,
     routing_keys: [
       {"user_action.*",
        queue: "#{exchange}_queue/user_action.*/rabbit_mq_ex",
        durable: true,
        dlq: "#{exchange}_dead_letter_queue"}
     ]}
  end

  defp exchange("service_request" = exchange) do
    {exchange,
     type: :topic,
     durable: true,
     routing_keys: [
       {"#",
        queue: "#{exchange}_queue/#/rabbit_mq_ex",
        durable: false,
        dlq: "#{exchange}_dead_letter_queue"}
     ]}
  end
end
