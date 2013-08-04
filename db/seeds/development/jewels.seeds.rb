['3Ro6o6okPFw', 'bDqr79kjmCE', 'XGFV4Ul9cEE', 'NGbZmcQg0lk', 'kiqRNoXuBgo', 'iYqtMfzLquA', 'oo-WU1madK4', 'TUFY_NixZCU',
 'Ji9NmckJ8g8', '0MiKp8CzcNs', '9EAhNgk6XPk', 'UZarVfjgHXY', '5KjC-lWTDtw', 'MmnSUI15X5s', 'tV_L-Cet7RA', 'bJlY_nl6MLo',
 'NblytNWvNRc', 'Nat0ZkZsumQ', 'vo8cB_3U3jQ', 'iWs6gwlTF5E', 'HvjziMbf0lg', 'APWjFMf4Hq4', 'Y4Zzs7IEIDQ', 'Y774exAPhsU',
 '1PTx051vFQo', 'cog-2wSxMYw', 'UAc-55GTX58', 'wKorJK3xEV0', 'SyG8yv8VzL0', 'tud1NdaSfhU', '67Dbl5D4N5w', 'ZwlW4800Fz0',
 'ijk1sCF48FI', 'jxSwnRoyGFU', '829BdEDQOzc', 'D288bP1Ep2c', 'SoMFts81zHw', '7dqBN6D6VGs', 'HRzIrCiXNEg', 'oO0pUJhzuiA',
 'K0PWoWh9Gog', '_mrJguOU40c'].each do |video|
  gem = Jewel.mine(User.last, "http://www.youtube.com/watch?v=#{video}")
end

['IohwMp6im1A', 'invCtzmdMs0', 'CDhIo7X77Mo'].each do |video|
  gem = Jewel.mine(User.first, "http://www.youtube.com/watch?v=#{video}")
end
