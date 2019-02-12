-- Quits the game
function do_quit(args)
  if settings.debug then print("Godbye.") end
  os.exit(0)
end

Command{
  token = "system",
  verbs = {"quit", "q"},
  func = do_quit
}
