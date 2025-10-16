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

    // Allows the owner to deduct a specified amount from a user's deposit as a penalty or fee.
    function deduct(address _depositor, uint256 _amount)
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

    // Allows users to withdraw their deposit after the lock duration has passed.
    function withdraw() external nonReentrant {
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

    // Returns the amount that a user can withdraw, considering deductions and lock duration.
    function getWithdrawableAmount(address _depositor)
        external
        view
        returns (uint256)
    {
        Deposit storage depositRecord = deposits[_depositor];
        // Check if deposit exists first
        if (depositRecord.amount == 0) {
            return 0;
        }
        if (block.timestamp >= depositRecord.releaseTime) {
            return depositRecord.amount - depositRecord.deductedAmount;
        }
        return 0;
    }

    // Returns the time left (in days and hours) until a user's deposit can be withdrawn.
    function getTimeLeftReadable(address _depositor)
        external
        view
        returns (uint256, uint256) // No names here
    {
        require(deposits[_depositor].amount > 0, "No deposit found");

        if (block.timestamp >= deposits[_depositor].releaseTime) {
            return (0, 0);
        } else {
            uint256 timeLeft = deposits[_depositor].releaseTime - block.timestamp;
            return (
                timeLeft / 86400, // days
                (timeLeft % 86400) / 3600 // hours
            );
        }
    }

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

    // Checks if a deposit exists for a given address.
    function hasDeposit(address _depositor) external view returns (bool) {
        return deposits[_depositor].amount > 0;
    }

    // Returns the current block timestamp for debugging purposes.
    function getCurrentTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

}