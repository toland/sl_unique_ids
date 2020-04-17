GlobalId.start_counter()

Benchee.run(
  %{
    "constant" => fn -> GlobalId.get_id(1) end,
    "simple_random" => fn -> GlobalId.get_id(GlobalId.simple_random_serial()) end,
    "strong_random" => fn -> GlobalId.get_id(GlobalId.strong_random_serial()) end,
    "counter" => fn -> GlobalId.get_id(GlobalId.counter_serial()) end
  },
  time: 10
  # parallel: 10,
  # fast_warning: false
)
