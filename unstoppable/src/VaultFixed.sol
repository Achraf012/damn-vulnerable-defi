// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VaultFixed is Ownable(msg.sender) {
    using SafeERC20 for IERC20;

    IERC20 public immutable asset;

    // Internal accounting for total assets
    uint256 public totalAssets;

    event FlashLoanStatus(bool success);

    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    // Update totalAssets only via controlled deposits/withdrawals
    function deposit(uint256 amount) external {
        require(amount > 0, "Zero amount");
        asset.safeTransferFrom(msg.sender, address(this), amount);
        totalAssets += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount <= totalAssets, "Not enough assets");
        totalAssets -= amount;
        asset.safeTransfer(msg.sender, amount);
    }

    // totalAssets no longer uses balanceOf(this)
    function getTotalAssets() public view returns (uint256) {
        return totalAssets;
    }

    // Flash loan check uses internal accounting
    function checkFlashLoan(uint256 amount) external onlyOwner {
        require(amount > 0, "Zero amount");

        uint256 before = totalAssets;

        // Simulate flash loan call here (omitted)

        uint256 afterx = totalAssets;
        if (afterx != before) {
            emit FlashLoanStatus(false);
            // pause or handle error
        } else {
            emit FlashLoanStatus(true);
        }
    }

    // Sweeper to recover rogue tokens sent directly to contract
    function sweepUnexpectedTokens(address to) external onlyOwner {
        uint256 actualBalance = asset.balanceOf(address(this));
        require(actualBalance > totalAssets, "No excess tokens");

        uint256 excess = actualBalance - totalAssets;
        asset.safeTransfer(to, excess);
    }
}
