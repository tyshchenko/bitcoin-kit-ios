class StateManager {
    private var storage: IStorage
    private var network: INetwork
    private let newWallet: Bool

    init(storage: IStorage, network: INetwork, newWallet: Bool) {
        self.storage = storage
        self.network = network
        self.newWallet = newWallet
    }

}

extension StateManager: IStateManager {

    var restored: Bool {
        get {
            guard network.syncableFromApi else {
                return true
            }

            guard !newWallet else {
                return true
            }

            return storage.initialRestored
        }
        set {
            storage.initialRestored = newValue
        }
    }

}
