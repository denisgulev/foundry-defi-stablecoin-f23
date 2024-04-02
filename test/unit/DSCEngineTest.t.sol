// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;
    DecentralizedStableCoin dsc;
    DSCEngine engine;
    HelperConfig config;
    address ethUsdPriceFeed;
    address weth;
    address notAllowedToken = address(0);

    address public USER = makeAddr("user");
    uint256 public constant AMOUNT_COLLATERAL = 10 ether;
    uint256 public constant STARTING_ERC20_BALANCE = 10 ether;

    //////////////
    /// Events ///
    //////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    /////////////////
    /// Modifiers ///
    /////////////////
    modifier startWithUser() {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(engine), AMOUNT_COLLATERAL);
        _;
    }

    function setUp() public {
        deployer = new DeployDSC();
        (dsc, engine, config) = deployer.run();
        (ethUsdPriceFeed,, weth,,) = config.activeNetworkConfig();
        // weth has a price of 2000e18, set in the HelperConfig file for local development
        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    ///////////////////
    /// Price Tests ///
    ///////////////////
    function testGetUsdValue() public view {
        uint256 ethAmount = 15e18;
        uint256 expectedUsd = 30000e18;
        uint256 actualUsd = engine.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

    ////////////////////////////////
    /// Deposit Collateral Tests ///
    ////////////////////////////////
    function testRevertsIfCollateralZero() public startWithUser {
        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        engine.depositCollateral(weth, 0);
    }

    function testRevertsIfCollateralTokenIsNotAllowed() public startWithUser {
        vm.expectRevert(DSCEngine.DSCEngine__TokenNotAllowed.selector);
        engine.depositCollateral(notAllowedToken, AMOUNT_COLLATERAL);
    }

    function testCollateralForUserIsUpdated() public startWithUser {
        assertEq(0 ether, engine.getCollateralForUser(USER));
        engine.depositCollateral(weth, AMOUNT_COLLATERAL);
        assertEq(AMOUNT_COLLATERAL, engine.getCollateralForUser(USER));
    }
}
