# 🛡️ DVD FlashLoan Bypass — Spoofed `totalAssets()` Exploit

## 📌 Summary

This repo demonstrates a simple but dangerous exploit in vault systems that **trust `balanceOf(this)` as their internal accounting**. By sending tokens directly to the vault, attackers can spoof the vault's `totalAssets()` and bypass safety checks like flashLoan verification.

---

## 🧨 Vulnerability

In the original vault:

```solidity
function totalAssets() public view returns (uint256) {
    return asset.balanceOf(address(this));
}
```

This is unsafe because **anyone can directly transfer tokens to the contract**, increasing `totalAssets()` without going through vault logic.

This leads to:

- Bypassed flashLoan checks
- Inconsistent share accounting
- Broken redeem logic
- Potential overminting or mispriced shares

---

## 🚨 Exploit Strategy

1. Deploy the vault.
2. Send extra tokens directly to the contract.
3. Call `checkFlashLoan(amount)`.
4. Vault believes it's balanced and emits `FlashLoanStatus(true)`, even though it was spoofed.

---

## ✅ Fixes in `VaultFixed.sol`

- `totalAssets` is tracked **internally**, not using `balanceOf(this)`.
- A `sweepUnexpectedTokens()` function lets the owner recover any rogue or mistaken token transfers.
- `checkFlashLoan()` now uses internal accounting and verifies balance integrity correctly.

---

## 🧪 Testing

Run with Foundry:

```bash
forge test -vvvv
```

## 📜 License

MIT
