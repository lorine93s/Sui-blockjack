/*
/// Module: blockjack
module blockjack::single_player_blockjack;
*/
module blackjack::single_player_blackjack {

    // Imports
    use sui::bls12381::bls12381_min_pk_verify;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::hash::{blake2b256};
    use sui::event::{Self};
    use sui::sui::SUI;
    use sui::address;
    use blackjack::counter_nft::Counter;


    // Constants
    const STAKE: u64 = 200000000;

    // Game statuses
    const IN_PROGRESS: u8 = 0;
    const PLAYER_WON_STATUS: u8 = 1;
    const HOUSE_WON_STATUS: u8 = 2;
    const TIE_STATUS: u8 = 3;


    // ---------------- Errors ----------------
    

    // ---------------- Structs ----------------                            


    // ---------------- Events ----------------
    public struct GameCreatedEvent has copy, drop {
        game_id: ID,
    }

    public struct HouseAdminCap has key {
        id: UID
    }

    // Configuration and Treasury object for the house.
    public struct HouseData has key {
        id: UID,
        balance: Balance<SUI>,
        house: address,
        public_key: vector<u8>
    }

    
    // ---------------- Functions ----------------
    /// Creates a new HouseCap object and transfers it to the sender.
    fun init(ctx: &mut TxContext) {
        let house_cap = HouseAdminCap {
            id: object::new(ctx)
        };

        transfer::transfer(house_cap, ctx.sender())
    }


    /// Initializer function that should only be called once and by the creator of the contract.
    /// Initializes the house data object. This object is involed in all games created by the same instance of this package.
    /// @param house_cap: The HouseCap object
    /// @param coin: The coin object that will be used to initialize the house balance. Acts as a treasury
    /// @param public_key: The public key of the house
    public entry fun initialize_house_data(
        house_cap: HouseAdminCap,
        coin: Coin<SUI>,
        public_key: vector<u8>,
        ctx: &mut TxContext
    ) {
        assert!(coin::value(&coin) > 0, EInsufficientBalance);

        let house_data = HouseData {
            id: object::new(ctx),
            balance: coin.into_balance(),
            house: ctx.sender(),
            public_key
        };

        let HouseAdminCap { id } = house_cap;
        object::delete(id);

        transfer::share_object(house_data);
    }

    // --------------- Accessors ---------------

    
    // --------------- For Testing ---------------
}    



