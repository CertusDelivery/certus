json.array!(@pickers) do |pick|
  json.partial! 'users/user', user: pick
end
