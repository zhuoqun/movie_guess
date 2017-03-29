Rails.application.config.middleware.use OmniAuth::Builder do
  provider :douban, '0b974d17dd201a9322c5e74797604fb9', '160df5e4f8b2fc90'
  provider :weibo, '1775762536', '8aeb5bf0c0e81b4e4f2933efaed0ac5e'
  provider :xiaonei, 'f1813f3e5156417ea37020bd6b449aae', '92867072c3b64a27aaee6c78e0aa9f33'
  provider :qq_connect, '100296872', 'c9c2f9e0533bb62b6cfb9cf2ebfdf876'
end
