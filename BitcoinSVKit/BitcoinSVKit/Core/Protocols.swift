import BitcoinCore
import BigInt

// BitcoinCore Compatibility

protocol IBitcoinSVDifficultyEncoder {
    func decodeCompact(bits: Int) -> BigInt
    func encodeCompact(from bigInt: BigInt) -> Int
}

protocol IBitcoinSVHasher {
    func hash(data: Data) -> Data
}

protocol IBitcoinSVBlockValidator {
    func validate(block: Block, previousBlock: Block) throws
    func isBlockValidatable(block: Block, previousBlock: Block) -> Bool
}

// ###############################

protocol IBitcoinSVBlockValidatorHelper {
    func medianTimePast(block: Block) -> Int
    func suitableBlockIndex(for blocks: [Block]) -> Int?

    func previous(for block: Block, count: Int) -> Block?
    func previousWindow(for block: Block, count: Int) -> [Block]?
}

protocol IBitcoinSVStorage {
    func timestamps(from startHeight: Int, to endHeight: Int, ascending: Bool) -> [Int]

    func block(byHash: Data) -> Block?
}

protocol IBlockValidatorHelperWrapper {
    func previous(for block: Block, count: Int) -> Block?
    func previousWindow(for block: Block, count: Int) -> [Block]?
}
