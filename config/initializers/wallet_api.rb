Peatio::Core::Wallet.registry[:bitcoind] = Bitcoin::Wallet.new
Peatio::Core::Wallet.registry[:geth] = Ethereum::Wallet.new
Peatio::Core::Wallet.registry[:parity] = Ethereum::Wallet.new
# Peth is deprecated and will be removed in future versions.
Peatio::Core::Wallet.registry[:peth] = Ethereum::Wallet.new
