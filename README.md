# TimeLockedBond - Sepolia Testnet

## Project Overview

TimeLockedBond is a smart contract deployed on the Sepolia testnet. It allows users to deposit ETH for a fixed duration, with the ability for the contract owner to deduct penalties or fees. The project includes a user-friendly frontend for both users and administrators.

---

## Features

- **User Deposits**: Users can lock ETH for a fixed duration.
- **Admin Deductions**: The contract owner can deduct penalties with reasons.
- **Withdrawal**: Users can withdraw their ETH after the lock duration.
- **Frontend Integration**: Includes `index.html` for users and `admin.html` for administrators.

---

## Prerequisites

- **Node.js**: v20.x or newer
- **npm**: Comes with Node.js
- **MetaMask**: Browser extension
- **Sepolia ETH**: Obtain from faucets
- **Alchemy API Key**: For Sepolia network access

---

## Setup Instructions

### 1. Install Dependencies

Run the following command in the project directory:

```bash
npm install
```

### 2. Environment Setup

Create a `.env` file in the project root with the following:

```env
ALCHEMY_API_KEY=your_alchemy_api_key_here
PRIVATE_KEY=your_private_key_here
```

**Important**: Never commit your `.env` file to version control.

### 3. Deploy the Contract

To deploy the contract to Sepolia, run:

```bash
npm run deploy:sepolia
```

### 4. Update Frontend Contract Address

Replace the contract address in `index.html` and `admin.html`:

```javascript
const contractAddress = "0x4a5f3678606424017C719C83561D17AbCC7eb9a1";
```

### 5. Run the Frontend

You can open `index.html` and `admin.html` directly in your browser, or use a local web server:

```bash
npx serve .
```

or

```bash
npx http-server .
```

### 6. Connect MetaMask

- Open MetaMask and switch to the "Sepolia test network".
- Ensure you have Sepolia ETH in your wallet.
- Use the account associated with your private key for admin functions.

### 7. Interact with the Contract

- **Users**: Use `index.html` to deposit ETH and check bond status.
- **Admins**: Use `admin.html` to manage deductions and view contract details.

---

## Contract Details

- **Contract Address**: `0x4a5f3678606424017C719C83561D17AbCC7eb9a1`
- **Network**: Sepolia Testnet
- **Duration**: 2 minutes (for testing purposes)

---

## Troubleshooting

### Common Issues

1. **Transaction Reverts**:
   - Ensure the depositor has sufficient balance.
   - Verify the deduction amount does not exceed the available balance.

2. **MetaMask Connection**:
   - Ensure MetaMask is connected to the Sepolia network.
   - Check if the wallet has sufficient Sepolia ETH.

3. **Contract Address Mismatch**:
   - Verify the contract address in the frontend matches the deployed address.

---

## Feedback and Contributions

This project is built using Hardhat 3 Beta. To learn more, visit the [Hardhat documentation](https://hardhat.org/docs/getting-started#getting-started-with-hardhat-3).

For feedback or contributions, join the [Hardhat 3 Beta Telegram group](https://hardhat.org/hardhat3-beta-telegram-group) or open an issue in the [GitHub repository](https://github.com/NomicFoundation/hardhat/issues/new).

---

## License

This project is licensed under the MIT License.


