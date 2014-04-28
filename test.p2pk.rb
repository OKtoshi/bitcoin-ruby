require 'pry'
Bitcoin.network = :testnet3

include Bitcoin::Builder

priv = "f457f5c3ce39c5041935f047525e3d12d74a7a4ba7321393bf8167a465051b99"
key = Bitcoin::Key.new(priv, nil, false)
p key.addr

unspent = {
  confirmations: 136,
  blockHeight: 226938,
  txHash: "7212ed1a1f095c3c2cdf0095268066fc2d731039dfd7dcded36d4f2b48252f0c",
  index: 0,
  scriptPubKey: "76a914652c453e3f8768d6d6e1f2985cb8939db91a4e0588ac",
  type: "pubkeyhash",
  value: 9500,
  hash160: "652c453e3f8768d6d6e1f2985cb8939db91a4e05",
  address: "mpjuaPusdVC5cKvVYCFX94bJX1SNUY8EJo"
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

