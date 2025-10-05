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

    // Owner deducts a penalty/fee from a deposit
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

    // Withdraw after 1 year
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

    // View remaining withdrawable amount
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

    // Get complete deposit information
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

    // Check if deposit exists for an address
    function hasDeposit(address _depositor) external view returns (bool) {
        return deposits[_depositor].amount > 0;
    }

    // Debug function to check current timestamp
    function getCurrentTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

}