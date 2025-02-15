Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Replace with frontend domain in production
    resource '*',
      headers: :any,
      expose: ['Authorization'],  # ✅ Allow frontend to read `Authorization`
      methods: [:get, :post, :patch, :put, :delete, :options]
  end
end