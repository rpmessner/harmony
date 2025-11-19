# Ensure the application is started before tests run
{:ok, _} = Application.ensure_all_started(:harmony)

ExUnit.start()
