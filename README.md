
# TimeLockedBond - Sepolia Testnet

## Project Setup Instructions

### Prerequisites

- Node.js v20.x or newer
- npm (comes with Node.js)
- MetaMask browser extension
- Sepolia testnet ETH (get from faucets)
- Alchemy API key for Sepolia access

### 1. Install Dependencies

Open a terminal in the project directory and run:

```
npm install
```

### 2. Environment Setup

Create a `.env` file in the project root with:

```
ALCHEMY_API_KEY=your_alchemy_api_key_here
PRIVATE_KEY=your_private_key_here
```

**Important**: Never commit your `.env` file to version control.

### 3. Deploy to Sepolia (if not already deployed)

```
npm run deploy:sepolia
```

### 4. Update Frontend Contract Address

In `admin.html` and `index.html`, replace the contract address with your Sepolia deployment address (look for `const contractAddress = "..."`).

### 5. Run the Frontend

You can open `index.html` and `admin.html` directly in your browser, or use a local web server for better compatibility:

```
npx serve .
```
or

```
npx http-server .
```

### 6. Connect MetaMask

- Open MetaMask and switch to the "Sepolia test network".
- Ensure you have Sepolia ETH in your wallet.
- Use the account associated with your private key for admin functions.

### 7. Interact with the Contract

- Use `index.html` for user deposits.
- Use `admin.html` for admin deductions and contract management.
- All interactions happen on Sepolia testnet.

---

This project showcases a Hardhat 3 Beta project deployed on Sepolia testnet using the native Node.js test runner (`node:test`) and the `viem` library for Ethereum interactions.

To learn more about the Hardhat 3 Beta, please visit the [Getting Started guide](https://hardhat.org/docs/getting-started#getting-started-with-hardhat-3). To share your feedback, join our [Hardhat 3 Beta](https://hardhat.org/hardhat3-beta-telegram-group) Telegram group or [open an issue](https://github.com/NomicFoundation/hardhat/issues/new) in our GitHub issue tracker.


