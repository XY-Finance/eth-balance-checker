// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// ERC20 contract interface
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract BalanceChecker {
    /// @notice Prevents accidental ETH transfers to the contract
    /// @dev Uses custom error instead of string for gas optimization
    error PaymentNotAccepted();

    receive() external payable {
        revert PaymentNotAccepted();
    }

    fallback() external payable {
        revert PaymentNotAccepted();
    }

    /// @notice Check the token balance of a wallet in a token contract
    /// @param user The address to check the balance for
    /// @param token The token contract address
    /// @return The token balance of the user
    /// @dev Uses try/catch for safer external calls
    function tokenBalance(address user, address token) public view returns (uint256) {
        if (token == address(0)) {
            return 0;
        }

        if (token.code.length == 0) {
            return 0;
        }

        try IERC20(token).balanceOf(user) returns (uint256 balance) {
            return balance;
        } catch {
            return 0;
        }
    }

    /// @notice Check token balances for multiple users and tokens
    /// @param users Array of user addresses
    /// @param tokens Array of token addresses (use address(0) for ETH)
    /// @return Array of balances
    /// @dev Improved input validation and gas optimization
    function balances(
        address[] calldata users,
        address[] calldata tokens
    ) external view returns (uint256[] memory) {
        uint256[] memory addrBalances = new uint256[](tokens.length * users.length);
        
        unchecked {
            // Using unchecked for gas optimization since we're unlikely to overflow
            // with realistic array lengths
            for(uint256 i = 0; i < users.length; i++) {
                for (uint256 j = 0; j < tokens.length; j++) {
                    uint256 addrIdx = j + tokens.length * i;
                    
                    if (tokens[j] == address(0)) {
                        addrBalances[addrIdx] = users[i].balance;
                    } else {
                        addrBalances[addrIdx] = tokenBalance(users[i], tokens[j]);
                    }
                }
            }
        }
    
        return addrBalances;
    }
}