require 'pry'
require 'helloblock-lite'
Bitcoin.network = :testnet3

include Bitcoin::Builder

priv = "f457f5c3ce39c5041935f047525e3d12d74a7a4ba7321393bf8167a465051b99"
key = Bitcoin::Key.new(priv, nil, false)

unspent = HelloBlock::Address.get_unspents(key.addr)[0]

binding.pry

new_tx = build_tx do |t|
  t.input do |i|
    i.prev_out unspent["txHash"]
    i.prev_out_index unspent["index"]
    i.prev_out_script [unspent["scriptPubKey"]].pack("H*")
    i.signature_key key
  end

  t.output do |o|
    o.value unspent["value"]
    o.script { |s| s.recipient("2N5snPEHUgsw5FjypjZ5zR8DQKqotmU5YAR") }
  end
end

p new_tx.payload.unpack("H*")[0]

