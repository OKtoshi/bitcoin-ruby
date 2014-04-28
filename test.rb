require 'pry'
Bitcoin.network = :testnet3

include Bitcoin::Builder

priv = "f457f5c3ce39c5041935f047525e3d12d74a7a4ba7321393bf8167a465051b99",

key = Bitcoin::Key.new(priv, nil, false)

unspent = {
  confirmations: 47437,
  blockHeight: 179635,
  txHash: "16aef10de77b91406a68d6446c10766969d4ba19f681d02293ca631f56d63768",
  index: 1,
  scriptPubKey: "76a914b472a266d0bd89c13706a4132ccfb16f7c3b9fcb88ac",
  type: "pubkeyhash",
  value: 30000,
  hash160: "b472a266d0bd89c13706a4132ccfb16f7c3b9fcb",
  address: "mwy5FX7MVgDutKYbXBxQG5q7EL6pmhHT58"
}

new_tx = build_tx do |t|
  t.input do |i|
    i.prev_out unspent[:txHash]
    i.prev_out_index unspent[:index]
    i.prev_out_script [unspent[:scriptPubKey]].pack("H*")
    i.signature_key key
  end

  t.output do |o|
    o.value unspent[:value]
    o.script { |s| s.recipient("mvaRDyLUeF4CP7Lu9umbU3FxehyC5nUz3L") }
  end
end

p new_tx.payload.unpack("H*")[0]

