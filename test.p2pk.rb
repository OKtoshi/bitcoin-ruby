require 'pry'
Bitcoin.network = :testnet3

include Bitcoin::Builder

privs = [
  "f457f5c3ce39c5041935f047525e3d12d74a7a4ba7321393bf8167a465051b99",
]

keys = privs.map do |priv|
  Bitcoin::Key.new(priv, nil, false)
end

keys[0].address

unspent = {
  confirmations: 1,
  blockHeight: 227071,
  txHash: 'cef3e503886b597bf67cea46c21f22f9ef8e238dad6f595dcd2a42c1c2eb61c9',
  index: 0,
  scriptPubKey: 'a9148a8b86cab5d35efea59c6fa9b416fbea07c7452f87',
  type: 'scripthash',
  value: 100000,
  hash160: '8a8b86cab5d35efea59c6fa9b416fbea07c7452f',
  address: '2N5snPEHUgsw5FjypjZ5zR8DQKqotmU5YAR' }

pubkeys = keys.map { |k| k.pub }.join(" ")
redeem_script = Bitcoin::Script.from_string("2 #{pubkeys} 3 OP_CHECKMULTISIG")

binding.pry

new_tx = build_tx({p2sh_multisig: true}) do |t|
  t.input do |i|
    i.prev_out unspent[:txHash]
    i.prev_out_index unspent[:index]
    i.prev_out_script redeem_script.raw
    i.signature_key keys[0..1]
  end

  t.output do |o|
    o.value unspent[:value]
    o.script { |s| s.recipient("mvaRDyLUeF4CP7Lu9umbU3FxehyC5nUz3L") }
  end
end

p new_tx.payload.unpack("H*")[0]

