Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '9jfwdvEVleTkxItJq719mQ', 'guukqq6LWvDPbTVKpcGv0qg9NWZfG3NXcJ9cKplxo'
  OmniAuth.config.full_host = 'http://www.thebasecamp.jp'

  #this is a test provider keys
  #provider :twitter, 'Phqo6RpoqCEPKJmMNKoQUQ', 'm8kuLcwD8JbNWey64lha943WkikPcHK4pI7ANrDXNA'
end