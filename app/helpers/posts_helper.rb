module PostsHelper
    def generate_short_url
      format('%04d', rand(10_000))
    end
  end
  