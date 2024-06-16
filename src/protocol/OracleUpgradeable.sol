// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import { ITSwapPool } from "../interfaces/ITSwapPool.sol";
import { IPoolFactory } from "../interfaces/IPoolFactory.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract OracleUpgradeable is Initializable {
    address private s_poolFactory;

    // can't have constructors
    // storage -> proxy
    // logic -> implementation -> constructor

    // @audit-info need to do zero addrerss check!
    // e main initializer function
    function __Oracle_init(address poolFactoryAddress) internal onlyInitializing {
        __Oracle_init_unchained(poolFactoryAddress);
    }

    // e initializer function but not main one because it's not being initialized on the main chain
    function __Oracle_init_unchained(address poolFactoryAddress) internal onlyInitializing {
        s_poolFactory = poolFactoryAddress;
    }

    // e omg we are calling an external contract
    // what if the price is manipulated?
    // can i manipulate the price?
    // reentrancy?
    // check the tests?
    // @audit informational - you should use forked tests for this!
    function getPriceInWeth(address token) public view returns (uint256) {
        address swapPoolOfToken = IPoolFactory(s_poolFactory).getPool(token);
        // e ignoring token decimals
        // q what if the token has 6 decimalls? is the price wrong?
        return ITSwapPool(swapPoolOfToken).getPriceOfOnePoolTokenInWeth();
    }

    // Redundant
    function getPrice(address token) external view returns (uint256) {
        return getPriceInWeth(token);
    }

    function getPoolFactoryAddress() external view returns (address) {
        return s_poolFactory;
    }
}

// ✅