# frozen_string_literal: true

module HomeHelper
  def randomized_background_image
    images = %w[
      backgrounds/home-fedex.png
      backgrounds/home-hawaii.png
      backgrounds/home-kiah.png
    ]

    asset_path(images[rand(images.size)])
  end
end
