# /recipes/fetch_recipe のPOSTリクエストに対して、1秒間に1回の制限
Rack::Attack.throttle('recipes/fetch_recipe', limit: 1, period: 1.seconds) do |req|
  if req.path == '/recipes/fetch_recipe' && req.post?
    req.ip
  end
end
