import BitcoinCore

class TestNet: INetwork {
    let bundleName = "LitecoinKit"

    let pubKeyHash: UInt8 = 0x6f
    let privateKey: UInt8 = 0xef
    let scriptHash: UInt8 = 0x3a
    let bech32PrefixPattern: String = "tltc"
    let xPubKey: UInt32 = 0x043587cf
    let xPrivKey: UInt32 = 0x04358394
    let magic: UInt32 = 0xfdd2c8f1
    let port: UInt32 = 19335
    let coinType: UInt32 = 1
    let sigHash: SigHashType = .bitcoinAll
    var syncableFromApi: Bool = false

    let dnsSeeds = [
        "testnet-seed.ltc.xurious.com",
        "seed-b.litecoin.loshan.co.uk",
        "dnsseed-testnet.thrasher.io",
    ]
    var bip44CheckpointBlock: Block {
        return Block(
                withHeader: BlockHeader(
                        version: 2,
                        headerHash: "000000000000bbde3a83bd29bc5cacd73f039f345318e7a4088914342c9d259a".reversedData!,
                        previousBlockHeaderHash: "0000000003dc49f7472f960eedb4fb2d1ccc8b0530ca6c75ed2bba9718b6f297".reversedData!,
                        merkleRoot: "a60fdbc889976c573450e9f78f1c330e374968a54f294e427180da1e9a07806b".reversedData!,
                        timestamp: 1393645018,
                        bits: 0x1c0180ab,
                        nonce: 634051227
                ),
                height: 199584)
    }

    var lastCheckpointBlock: Block {
        return Block(
                withHeader: BlockHeader(
                        version: 1073676288,
                        headerHash: "00000000000001d6d3fcee88c80ac371d82b370f0158cc2737bebad6d13ff47b".reversedData!,
                        previousBlockHeaderHash: "00000000000000525de83fba2439549ef0ed78d6d08516a0513abb972b0fca95".reversedData!,
                        merkleRoot: "1c2f9a7885b2334096fbc1cd1373a1ac6d42b3eacee91d32758bb6f9f5018670".reversedData!,
                        timestamp: 1565789713,
                        bits: 436336433,
                        nonce: 1552477045
                ),
                height: 1574496)
    }
    let dustRelayTxFee = 3000 // https://github.com/bitcoin/bitcoin/blob/c536dfbcb00fb15963bf5d507b7017c241718bf6/src/policy/policy.h#L50
}
