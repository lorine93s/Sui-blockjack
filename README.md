# Sui Blockjack Game

## Overview
Sui Blockjack is a decentralized card game built on the Sui blockchain. It combines the classic Blackjack gameplay with the power of blockchain technology, ensuring transparency, fairness, and immutability. Players can interact with the game using their crypto wallets and enjoy a seamless gaming experience.

## Project Structure
```
Sui-blockjack/
├── contracts/          # Smart contracts written in Move
├── frontend/           # Frontend application (React/Next.js)
├── scripts/            # Deployment and utility scripts
├── tests/              # Unit and integration tests
├── README.md           # Project documentation
└── package.json        # Project dependencies and scripts
```

## How to Start the Game
1. **Clone the Repository**  
    ```bash
    git clone https://github.com/lorine93s/Sui-blockjack.git
    cd sui-blockjack
    ```

2. **Install Dependencies**  
    ```bash
    npm install
    ```

3. **Deploy Smart Contracts**  
    Ensure you have the Sui CLI installed and configured. Then, deploy the contracts:  
    ```bash
    sui move publish 
    ```

4. **Run the Frontend**  
    Start the frontend application:  
    ```bash
    npm run dev
    ```

5. **Play the Game**  
    Open your browser and navigate to `http://localhost:3000`. Connect your wallet and start playing!

## Features
- Decentralized gameplay powered by Sui blockchain.
- Transparent and fair card dealing.
- Wallet integration for seamless transactions.
- Leaderboard to track top players.

## Prerequisites
- Node.js and npm installed.
- Sui CLI installed and configured.
- A Sui-compatible wallet (e.g., Sui Wallet).

## Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
## Author
Kien Lam
