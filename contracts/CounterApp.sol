pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";
import "./i-bladerunner.sol";

contract CounterApp is AragonApp {
    using SafeMath for uint256;

    IBladeRunner bladeRunner;

    /// Events
    event Increment(address indexed entity, uint256 step);
    event Decrement(address indexed entity, uint256 step);

    /// State
    uint256 public value;

    /// ACL
    bytes32 constant public INCREMENT_ROLE = keccak256("INCREMENT_ROLE");
    bytes32 constant public DECREMENT_ROLE = keccak256("DECREMENT_ROLE");

    function initialize(uint256 _initValue) public onlyInit {
        value = _initValue;

        initialized();
    }

    /**
     * @notice Increment the counter by `step`
     * @param step Amount to increment by
     */
    function increment(uint256 step) external auth(INCREMENT_ROLE) {
        value = value.add(step);
        emit Increment(msg.sender, step);
    }

    /**
     * @notice Decrement the counter by `step`
     * @param step Amount to decrement by
     */
    function decrement(uint256 step) external auth(DECREMENT_ROLE) {
        value = value.sub(step);
        emit Decrement(msg.sender, step);
    }

    /**
     * @notice Attach BladeRunner instance
     * @param bladeRunnerAddress Address of existing Bladerunner managing an Upala group
     */
    function attachBladeRunner(address bladeRunnerAddress) external {
        require(
            IBladeRunner(bladeRunnerAddress).isUpalaGroup(),
            "The contract you are trying to attach is not a Bladerunner");
        bladeRunner = IBladeRunner(bladeRunnerAddress);
    }
    function announceAndSetBotReward(uint256 newBotReward) external {
        bladeRunner.announceAndSetBotReward(newBotReward);
    }
}