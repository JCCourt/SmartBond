// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./ReentrancyGuard.sol";

contract TimeLockedBond is Ownable, ReentrancyGuard {
    struct Deposit {
        address payable depositor;
        uint256 amount;
        uint256 releaseTime;
        uint256 deductedAmount;
    }

    mapping(address => Deposit) private deposits;
    uint256 public constant DURATION = 2 minutes; // Short duration for testing

    // Events
    event Deposited(
        address indexed depositor,
        uint256 amount,
        uint256 releaseTime
    );
    event Withdrawn(address indexed depositor, uint256 amount);
    event Deducted(
        address indexed depositor,
        uint256 amount,
        uint256 remaining
    );

    // Fixed: Single constructor passing initialOwner to both Ownable and ReentrancyGuard
    constructor(address _initialOwner)
        Ownable(_initialOwner)
        ReentrancyGuard()
    {}

    // =====================================================================
    // WRITE FUNCTIONS - State-changing operations
    // =====================================================================

    // WRITE FUNCTION - Stores user deposit data
    // Stores: User address, deposit amount, release time, and deducted amount (initialized to 0)
    // Mapping: deposits[msg.sender] = Deposit struct
    // Allows users to deposit ETH into the contract, locking it for a fixed duration.
    function depositETH() external payable {
        require(msg.value > 0, "Amount must be > 0");
        deposits[msg.sender] = Deposit({
            depositor: payable(msg.sender),
            amount: msg.value,
            releaseTime: block.timestamp + DURATION,
            deductedAmount: 0
        });
        emit Deposited(msg.sender, msg.value, deposits[msg.sender].releaseTime);
    }

    // WRITE FUNCTION - Deducts amount from user deposit
    // Stores: Updates deductedAmount field in deposits mapping for the specified depositor
    // Transfers deducted ETH to contract owner
    // Mapping: deposits[_depositor].deductedAmount updated
    // Allows the owner to deduct a specified amount from a user's deposit as a penalty or fee.
    function deductETH(address _depositor, uint256 _amount)
        external
        onlyOwner
        nonReentrant
    {
        Deposit storage depositRecord = deposits[_depositor];
        require(depositRecord.amount > 0, "No deposit exists");
        require(_amount > 0, "Deduction must be > 0");
        require(
            depositRecord.amount >= depositRecord.deductedAmount + _amount,
            "Deduction exceeds deposit"
        );

        depositRecord.deductedAmount += _amount;
        payable(owner()).transfer(_amount);

        emit Deducted(
            _depositor,
            _amount,
            depositRecord.amount - depositRecord.deductedAmount
        );
    }

    // WRITE FUNCTION - Withdraws user deposit and deletes deposit record
    // Stores: Deletes deposits[msg.sender] entry from mapping after withdrawal
    // Transfers withdrawable amount to user
    // Mapping: deposits[msg.sender] deleted
    // Allows users to withdraw their deposit after the lock duration has passed.
    function withdrawETH() external nonReentrant {
        Deposit storage depositRecord = deposits[msg.sender];
        require(depositRecord.amount > 0, "No deposit exists");
        require(
            block.timestamp >= depositRecord.releaseTime,
            "Funds locked until release time"
        );

        uint256 withdrawableAmount = depositRecord.amount -
            depositRecord.deductedAmount;
        require(withdrawableAmount > 0, "No funds left after deductions");

        depositRecord.depositor.transfer(withdrawableAmount);
        delete deposits[msg.sender];

        emit Withdrawn(msg.sender, withdrawableAmount);
    }

    // =====================================================================
    // READ FUNCTIONS - View-only operations (no state changes)
    // =====================================================================

    // READ FUNCTION - No data storage
    // Reads from: deposits mapping (complete Deposit struct for depositor)
    // Returns: Deposit amount, release time, deducted amount, available amount, and withdrawal status
    // Returns detailed information about a user's deposit, including amounts and withdrawable status.
    function getDepositInfo(address _depositor)
        external
        view
        returns (
            uint256 amount,
            uint256 releaseTime,
            uint256 deductedAmount,
            uint256 availableAmount,
            bool isWithdrawable
        )
    {
        Deposit storage depositRecord = deposits[_depositor];
        require(depositRecord.amount > 0, "No deposit found");
        
        uint256 available = 0;
        bool withdrawable = false;
        
        // Always calculate available amount if expired
        if (block.timestamp >= depositRecord.releaseTime) {
            available = depositRecord.amount - depositRecord.deductedAmount;
            withdrawable = available > 0;
        }
        
        return (
            depositRecord.amount,
            depositRecord.releaseTime,
            depositRecord.deductedAmount,
            available,
            withdrawable
        );
    }

    // READ FUNCTION - No data storage
    // Reads from: deposits mapping (checks if amount > 0 for depositor)
    // Returns: Boolean indicating if a deposit exists for the given address
    function hasDeposit(address _depositor) external view returns (bool) {
        return deposits[_depositor].amount > 0;
    }

}