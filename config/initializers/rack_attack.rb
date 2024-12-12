# /recipes/fetch_recipe のPOSTリクエストに対して、1秒間に1回の制限
Rack::Attack.throttle('recipes/fetch_recipe', limit: 1, period: 1.seconds) do |req|
  if req.post? && ['/recipes/fetch_recipe', '/recipes/search', '/recipes/search_show'].include?(req.path)
    req.ip
  end
end
