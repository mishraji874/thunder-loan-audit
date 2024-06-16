// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

// e this is probably the interface to work from PoolFactory.sol from TSwap
// q why are we using tswap?
// ans we need it to get the value of a token to calculate the fees!
interface IPoolFactory {
    function getPool(address tokenAddress) external view returns (address);
}

// ✅