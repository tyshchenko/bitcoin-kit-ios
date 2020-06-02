import BitcoinCore
import HSHDWalletKit
import BigInt
import HSCryptoKit
import RxSwift

public class BitcoinSVKit: AbstractKit {
    private static let name = "BitcoinSVKit"
    private static let svChainForkHeight = 556767                                  // 2018 November 14
    private static let abcChainForkBlockHash = "0000000000000000004626ff6e3b936941d341c5932ece4357eeccac44e6d56c".reversedData!


    private static let heightInterval = 144                                     // Blocks count in window for calculating difficulty ( BitcoinSV )
    private static let targetSpacing = 10 * 60                                  // Time to mining one block ( 10 min. same as Bitcoin )
    private static let maxTargetBits = 0x1d00ffff                               // Initially and max. target difficulty for blocks

    public enum NetworkType: String, CaseIterable { case mainNet, testNet }

    public weak var delegate: BitcoinCoreDelegate? {
        didSet {
            bitcoinCore.delegate = delegate
        }
    }

    private let storage: IBitcoinSVStorage

    public init(withWords words: [String], walletId: String, syncMode: BitcoinCore.SyncMode = .api, networkType: NetworkType = .mainNet, confirmationsThreshold: Int = 6, minLogLevel: Logger.Level = .verbose) throws {
        let network: INetwork
        let initialSyncApiUrl: String

        let validScheme: String
        switch networkType {
            case .mainNet:
                network = MainNet()
                initialSyncApiUrl = "https://blockdozer.com/api/"
                validScheme = "bitcoinsv"
            case .testNet:
                network = TestNet()
                initialSyncApiUrl = "https://tbch.blockdozer.com/api/"
                validScheme = "bchtest"
        }
        let initialSyncApi = InsightApi(url: initialSyncApiUrl)

        let databaseFilePath = try DirectoryHelper.directoryURL(for: BitcoinSVKit.name).appendingPathComponent(BitcoinSVKit.databaseFileName(walletId: walletId, networkType: networkType)).path
        let storage = BitcoinSVGrdbStorage(databaseFilePath: databaseFilePath)
        self.storage = storage

        let paymentAddressParser = PaymentAddressParser(validScheme: validScheme, removeScheme: false)

        let bitcoinCore = try BitcoinCoreBuilder(minLogLevel: minLogLevel)
                .set(network: network)
                .set(initialSyncApi: initialSyncApi)
                .set(words: words)
                .set(paymentAddressParser: paymentAddressParser)
                .set(walletId: walletId)
                .set(confirmationsThreshold: confirmationsThreshold)
                .set(peerSize: 10)
                .set(syncMode: syncMode)
                .set(storage: storage)
                .build()

        super.init(bitcoinCore: bitcoinCore, network: network)

        // extending BitcoinCore
        let bech32 = CashBech32AddressConverter(prefix: network.bech32PrefixPattern)
        bitcoinCore.prepend(addressConverter: bech32)

        let coreBlockHelper = BlockValidatorHelper(storage: storage)
        let blockHelper = BitcoinSVBlockValidatorHelper(storage: storage, coreBlockValidatorHelper: coreBlockHelper)
        let difficultyEncoder = DifficultyEncoder()

        let daaValidator = DAAValidator(encoder: difficultyEncoder, blockHelper: blockHelper, targetSpacing: BitcoinSVKit.targetSpacing, heightInterval: BitcoinSVKit.heightInterval, firstCheckpointHeight: network.lastCheckpointBlock.height)

        switch networkType {
        case .mainNet:
            bitcoinCore.add(blockValidator: ForkValidator(concreteValidator: daaValidator, forkHeight: BitcoinSVKit.svChainForkHeight, expectedBlockHash: BitcoinSVKit.abcChainForkBlockHash))
            bitcoinCore.add(blockValidator: daaValidator)
            bitcoinCore.add(blockValidator: LegacyDifficultyAdjustmentValidator(encoder: difficultyEncoder, blockValidatorHelper: coreBlockHelper, heightInterval: BitcoinCore.heightInterval, targetTimespan: BitcoinCore.targetSpacing * BitcoinCore.heightInterval, maxTargetBits: BitcoinCore.maxTargetBits))
            bitcoinCore.add(blockValidator: EDAValidator(encoder: difficultyEncoder, blockHelper: blockHelper, maxTargetBits: BitcoinCore.maxTargetBits, firstCheckpointHeight: network.bip44CheckpointBlock.height))
        case .testNet: ()
            // not use test validators
        }

        bitcoinCore.add(restoreKeyConverterForBip: .bip44)
    }

}

extension BitcoinSVKit {

    public static func clear(exceptFor walletIdsToExclude: [String] = []) throws {
        var excludedFileNames = [String]()

        for walletId in walletIdsToExclude {
            for type in NetworkType.allCases {
                excludedFileNames.append(databaseFileName(walletId: walletId, networkType: type))
            }
        }

        try DirectoryHelper.removeAll(inDirectory: BitcoinSVKit.name, except: excludedFileNames)
    }

    private static func databaseFileName(walletId: String, networkType: NetworkType) -> String {
        return "\(walletId)-\(networkType.rawValue)"
    }

}
