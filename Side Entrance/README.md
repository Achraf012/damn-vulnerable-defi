# Side Entrance Challenge 🏦

This challenge is from **Damn Vulnerable DeFi**, focused on exploiting a smart contract that allows flash loans with a flawed accounting system.

## 🎯 Goal

Drain all ETH from the `SideEntranceLenderPool` using a malicious contract.

## 🧠 Vulnerability

The pool assumes that any `deposit()` during a flash loan counts as valid repayment. This allows re-entering during the loan and tricking the contract into thinking the loan is repaid, while gaining withdrawal rights.

## 🚨 Exploit Summary

- Take a flash loan for the full balance.
- Inside `execute()`, immediately deposit the loaned ETH back.
- This tricks the contract into marking the flash loan as repaid.
- Then, withdraw the deposit as if it were yours.
- 
📚 Lessons Learned
-Deposits and internal accounting must be isolated from flash loan logic.

-Always question what counts as “repayment” in lending protocols.

-Reentrancy doesn't need to happen from receive()—execute() logic can be twisted too.


