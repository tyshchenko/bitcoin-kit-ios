import BitcoinCore

class MainNet: INetwork {
    let bundleName = "LitecoinKit"

    let pubKeyHash: UInt8 = 0x30
    let privateKey: UInt8 = 0xb0
    let scriptHash: UInt8 = 0x32
    let bech32PrefixPattern: String = "ltc"
    let xPubKey: UInt32 = 0x0488b21e
    let xPrivKey: UInt32 = 0x0488ade4
    let magic: UInt32 = 0xfbc0b6db
    let port: UInt32 = 9333
    let coinType: UInt32 = 2
    let sigHash: SigHashType = .bitcoinAll
    var syncableFromApi: Bool = true

    let dnsSeeds = [
        "dnsseed.litecoinpool.org",
        "seed-a.litecoin.loshan.co.uk",
        "dnsseed.thrasher.io",
        "dnsseed.koin-project.com",
        "dnsseed.litecointools.com",
    ]
    var bip44CheckpointBlock: Block {
        return Block(
                withHeader: BlockHeader(
                        version: 2,
                        headerHash: "00000000000000003decdbb5f3811eab3148fbc29d3610528eb3b50d9ee5723f".reversedData!,
                        previousBlockHeaderHash: "00000000000000006bcf448b771c8f4db4e2ca653474e3b29504ec08422b3fba".reversedData!,
                        merkleRoot: "4ea18e999a57fc55fb390558dbb88a7b9c55c71c7de4cec160c045802ee587d2".reversedData!,
                        timestamp: 1397755646,
                        bits: 419470732,
                        nonce: 2160181286
                ),
                height: 296352)
    }

    var lastCheckpointBlock: Block {
        return Block(
                withHeader: BlockHeader(
                        version: 549453824,
                        headerHash: "0000000000000000000bab9600a8e7593e2b13ea061c88f1c107a282ee75830b".reversedData!,
                        previousBlockHeaderHash: "00000000000000000016e0dd8fe86bf34feaa611b4c52180b6822b5ad31b68ff".reversedData!,
                        merkleRoot: "e99b5d4feb6d70c056022b579c3ed70d249e66a1cd2fde6b06fa52dc68b9e480".reversedData!,
                        timestamp: 1566161382,
                        bits: 387687377,
                        nonce: 5141340
                ),
                height: 590688)
    }
    
    let dustRelayTxFee = 3000 // https://github.com/bitcoin/bitcoin/blob/c536dfbcb00fb15963bf5d507b7017c241718bf6/src/policy/policy.h#L50
}
