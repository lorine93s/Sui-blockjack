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
    const EInvalidBlsSig: u64 = 10;
    const EInsufficientBalance: u64 = 11;
    const EInsufficientHouseBalance: u64 = 12;
    const EGameHasFinished: u64 = 13;
    const EUnauthorizedPlayer: u64 = 14;
    const EDealAlreadyHappened: u64 = 15;
    const EInvalidGameOfHitRequest: u64 = 16;
    const EInvalidGameOfStandRequest: u64 = 17;
    const EInvalidSumOfHitRequest: u64 = 18;
    const EInvalidSumOfStandRequest: u64 = 19;
    const EInvalidPlayerBetAmount: u64 = 20;
    const ECallerNotHouse: u64 = 21;
    const EInvalidTwentyOneSumOfHitRequest: u64 = 22;

    // ---------------- Structs ----------------                           

    // ---------------- Events ----------------
    public struct GameCreatedEvent has copy, drop {
        game_id: ID,
    }

    public struct GameOutcomeEvent has copy, drop {
        game_id: ID,
        game_status: u8,
        winner_address: address,
        message: vector<u8>,
    }

    public struct HitDoneEvent has copy, drop {
        game_id: ID,
        current_player_hand_sum: u8,
        player_cards: vector<u8>
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

    public struct Game has key {
        id: UID,
        user_randomness: vector<u8>,
        total_stake: Balance<SUI>,
        player: address,
        player_cards: vector<u8>,
        player_sum: u8,
        dealer_cards: vector<u8>,
        dealer_sum: u8,
        status: u8,
        counter: u8,
    }

    public struct HitRequest has key, store {
        id: UID,
        game_id: ID,
        current_player_sum: u8,
    }

    public struct StandRequest has key, store {
        id: UID,
        game_id: ID,
        current_player_sum: u8,
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

    /// Function used to create a new game. The player must provide a random vector of bytes.
    /// Stake is taken from the player's coin and added to the game's stake. The house's stake is also added to the game's stake.
    /// @param user_randomness: A vector of randomly produced bytes that will be used to calculate the result of the VRF
    /// @param user_counter: A user counter object that serves as additional source of randomness.
    /// @param user_bet: The coin object that will be used to take the player's stake
    /// @param house_data: The HouseData object
    public entry fun place_bet_and_create_game(
        user_randomness: vector<u8>,
        user_counter: &mut Counter,
        user_bet: Coin<SUI>,
        house_data: &mut HouseData,
        ctx: &mut TxContext
    ) {
        // Ensure that the house has enough balance to play for this game
        assert!(house_data.balance() >= STAKE, EInsufficientHouseBalance);

        // get the user coin and convert it into a balance
        assert!(user_bet.value() == STAKE, EInvalidPlayerBetAmount);
        let mut stake = user_bet.into_balance();

        // get the house balance
        let house_stake = house_data.balance.split(STAKE);
        stake.join(house_stake);

        let mut initial_randomness = user_randomness;
        initial_randomness.append(user_counter.increment_and_get());

        let new_game = Game {
            id: object::new(ctx),
            user_randomness: initial_randomness,
            total_stake: stake,
            player: ctx.sender(),
            player_cards: vector[],
            player_sum: 0,
            dealer_cards: vector[],
            dealer_sum: 0,
            status: IN_PROGRESS,
            counter: 0
        };

        event::emit(GameCreatedEvent {
            game_id: object::id(&new_game)
        });

        transfer::share_object(new_game);
    }

    // --------------- Accessors ---------------

    
    // --------------- For Testing ---------------
}    



