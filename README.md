#### STABLECOIN

1. (relative stability) anchored or pegged -> $1
    1. chainlink price feed
    2. set a fnc to exchange ETH/BTC for $$$
2. stability mechanism (MINTING): Algorithmic (decentralized)
    1. people can only mint with collateral
3. collateralType: Exogenous (crypto)
    1. wETH
    2. wBTC

####
Define following function in the engine:
1. depositCollateral
2. mintDsc
    - keep track of how much a specific user has minted
    - check if amountToBeMinted respects the HealthFactor (see. AAVE docs for more info)

- write deploy script with a HelperConfig file to retrieve input parameters for DSCEngine and DecentralizedStableCoin

- write some test for the deploy script

- Implement redeem function (be sure to check healthFactor after the transfer)
    - if a user have some DSC minted and want to redeem ALL his collateral, it will fail, as there are some DSC to his name;
    to avoid this failure, we should BURN first it's tokens and redeem all collateral afterwards

- Implement liquidate function (we want to remove positions of user in the system, if it's collateral price tanks)
    - If userA's position goes below healthFactor, another user can BUY it's position, by paying for userA's token-collateralized at a advatagious price 
        and liquidate (BURN) userA's DSCs

#### ATTACKS

1. Reentrancy - one of the most common attacks


#### TESTING LAYERS

1. Unit Tests (bare-minimum)
2. Fuzz Tests 
3. Static Analysis
4. Formal Verification -> uses mathematical proofs to try and break the code
    This has different techniques to be evalued:
    - Symbolic Execution -> explore different parts of a program and create a mathematical representation for each of them;
                            prove or disprove properties of a function using mathematical mode


#### FUZZ TESTING

Fuzz testing is a way to test a code, by supplying random inputs in an attempt to break it.

- in Foundry, a basic example of fuzz testing is to set an input parameter to the testing function, which will be used to call the ontract's function we want to test.

There are two main ways to use fuzz testing:
1. Stateless Fuzz Testing
    which means that when running multiple iterations of a fuzz tests, the state of the a previous run will be discarded

2. Stateful Fuzz Testing
    this means that the state of an iteration of the fuzz test will be the initial state of the next run
    ** to take advatage of this kind of tests, we must use the "invariant" keyword

What are the invariants/properties? (Property of the system the must remain the same.)


--> OpenInvariantsTest:
    such invariant tests are great for a quick run on simple contracts that contain functions which do not have pre-requisite.
    (example:
        in the DSCEngine contract, to call the 'redeemCollateral' function, a user must have first deposited collateral with accepted collateralToken address
    )

--> InvariantsTest:
    create a handler with a logical-sequentiality for the functions to be called
    (i.e. don't call 'redeemCollater' if the is no collateral to be redeemed)

    the handler is defined in "Handler.t.sol":
        in here we will make sure that certain functions can be called during the tests only if 
        there are some pre-requisites

    -> to track if a function is being called, we can use ghost variables


### Oracle Usage

We should add some checks for the oracle functions we are using, in order to assure that if some of these breaks, our contract does not breaks.

- for PriceFeed utility, we want to make sure that the prices do not remain stale
    each pricefeed has a heartbeat of X seconds, we wanna make sure to receive a new price every X seconds

    For this we can define a library and link it to the priceFeed type, so we can make use of the checks defined in the library.

