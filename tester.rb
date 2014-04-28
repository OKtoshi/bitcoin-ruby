require 'pry'
Bitcoin.network = :testnet3

include Bitcoin::Builder

priv = "f457f5c3ce39c5041935f047525e3d12d74a7a4ba7321393bf8167a465051b99"

key = Bitcoin::Key.new(priv, nil, false)

unspent = { confirmations: 199,
  blockHeight: 226766,
  txHash: '6a92ada82bbb1c7319bb21939bcdf12a74928755ca53fbc06bd7e1e590a03176',
  index: 0,
  scriptPubKey: 'a91401c99a9a2756f7ab5e6b0f798eefbb1c434727b387',
  type: 'scripthash',
  value: 20000,
  hash160: '01c99a9a2756f7ab5e6b0f798eefbb1c434727b3',
  address: '2MsQgBAK2S4XkE49cwKccrwaifgPxnuSpKq' }

redeem_script = Bitcoin::Script.from_string("1 #{key.pub} #{key.pub} #{key.pub} 3 OP_CHECKMULTISIG")

new_tx = build_tx({p2sh_multisig: true}) do |t|
  t.input do |i|
    i.prev_out unspent[:txHash]
    i.prev_out_index unspent[:index]
    i.prev_out_script redeem_script.raw
    i.signature_key(key)
  end

  t.output do |o|
    o.value unspent[:value]
    o.script { |s| s.recipient("mvaRDyLUeF4CP7Lu9umbU3FxehyC5nUz3L") }
  end
end

p new_tx.payload.unpack("H*")[0]
