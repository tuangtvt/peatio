Peatio::Core::Blockchain.registry[:bitcoin] = Bitcoin::Blockchain.new
Peatio::Core::Blockchain.registry[:geth] = Ethereum::Blockchain.new
Peatio::Core::Blockchain.registry[:parity] = Ethereum::Blockchain.new
