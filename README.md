
# TimeLockedBond Hardhat Project

## Project Setup Instructions

### Prerequisites

- Node.js v20.x or newer
- npm (comes with Node.js)
- MetaMask browser extension (for interacting with the frontend)

### 1. Install Dependencies

Open a terminal in the project directory and run:

```
npm install
```

### 2. Start Hardhat Local Node

In the project directory, start the local blockchain:

```
npx hardhat node
```
Leave this terminal open.

### 3. Deploy the Contract

Open a new terminal in the same directory and run:

```
npx hardhat run --network localhost scripts/deploy.js
```
Note: Update `scripts/deploy.js` if your deployment script is named differently.

Copy the deployed contract address from the output.

### 4. Update Frontend Contract Address

In `admin.html` and `index.html`, replace the contract address with the one from your deployment (look for `const contractAddress = "..."`).

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

- Open MetaMask and switch to the "Localhost 8545" network.
- Import the admin account using its private key (see Hardhat node output for accounts and keys).

### 7. Interact with the Contract

- Use `index.html` for user deposits.
- Use `admin.html` for admin deductions and contract management.

---

This project showcases a Hardhat 3 Beta project using the native Node.js test runner (`node:test`) and the `viem` library for Ethereum interactions.

To learn more about the Hardhat 3 Beta, please visit the [Getting Started guide](https://hardhat.org/docs/getting-started#getting-started-with-hardhat-3). To share your feedback, join our [Hardhat 3 Beta](https://hardhat.org/hardhat3-beta-telegram-group) Telegram group or [open an issue](https://github.com/NomicFoundation/hardhat/issues/new) in our GitHub issue tracker.


