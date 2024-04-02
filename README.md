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

                            