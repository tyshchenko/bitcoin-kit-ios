import XCTest
import Cuckoo
import RealmSwift
import RxSwift
@testable import HSBitcoinKit

class StateManagerTests: XCTestCase {
    private var mockStorage: MockIStorage!
    private var mockNetwork: MockINetwork!

    private var manager: StateManager!

    override func setUp() {
        super.setUp()

        mockStorage = MockIStorage()
        mockNetwork = MockINetwork()

        stub(mockStorage) { mock in
            when(mock.initialRestored.set(any())).thenDoNothing()
        }

        manager = StateManager(storage: mockStorage, network: mockNetwork, newWallet: false)
    }

    override func tearDown() {
        mockStorage = nil
        mockNetwork = nil

        manager = nil

        super.tearDown()
    }

    func testRestored_get_notSyncableFromApi() {
        stub(mockNetwork) { mock in
            when(mock.syncableFromApi.get).thenReturn(false)
        }

        XCTAssertTrue(manager.restored)
    }

    func testRestored_get_newWallet() {
        stub(mockNetwork) { mock in
            when(mock.syncableFromApi.get).thenReturn(true)
        }

        let manager = StateManager(storage: mockStorage, network: mockNetwork, newWallet: true)

        XCTAssertTrue(manager.restored)
    }

    func testRestored_get_true() {
        stub(mockNetwork) { mock in
            when(mock.syncableFromApi.get).thenReturn(true)
        }
        stub(mockStorage) { mock in
            when(mock.initialRestored.get).thenReturn(true)
        }

        XCTAssertTrue(manager.restored)
    }

    func testRestored_get_false() {
        stub(mockNetwork) { mock in
            when(mock.syncableFromApi.get).thenReturn(true)
        }
        stub(mockStorage) { mock in
            when(mock.initialRestored.get).thenReturn(false)
        }

        XCTAssertFalse(manager.restored)
    }

    func testRestored_set_true() {
        manager.restored = true

        verify(mockStorage).initialRestored.set(true)
    }

    func testRestored_set_false() {
        manager.restored = false

        verify(mockStorage).initialRestored.set(false)
    }

}
