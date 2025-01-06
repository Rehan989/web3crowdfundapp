# Decentralized Crowdfunding Platform

Full-stack crowdfunding platform built with Next.js and Solidity smart contracts, deployed on Ethereum Sepolia testnet using thirdweb.

## 🌟 Features

- Create and manage crowdfunding campaigns
- Multi-wallet support (MetaMask, WalletConnect, Coinbase Wallet)
- Tiered reward system
- Automated refund system
- Responsive Next.js frontend
- Real-time campaign status updates
- Campaign deadline extension
- Pause/unpause functionality

## 🔧 Tech Stack

### Frontend
- Next.js
- TypeScript
- thirdweb React SDK
- Tailwind CSS
- React Query

### Backend
- Solidity ^0.8.0
- thirdweb SDK
- Ethereum Sepolia Testnet

## 📦 Project Structure

```
├── contracts/
│   ├── CrowdfundingFactory.sol
│   └── Crowdfunding.sol
├── frontend/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   └── utils/
└── scripts/
```

## 🚀 Deployment

### Smart Contracts (Sepolia)
```
Factory Contract: [Your Factory Contract Address]
```

### Frontend
```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build
```

## 🔗 Supported Wallets

- MetaMask
- Phantom
- WalletConnect
- Coinbase Wallet
- Rainbow Wallet
- See lisk of wallets accepted here: [here][https://portal.thirdweb.com/wallet-sdk/v2/wallets]

## 📹 Demo

Watch the demo video [here][Add your video link].

## 🛠 Local Development

1. Clone repository
```bash
git clone [Your Repository URL]
```

2. Install dependencies
```bash
# Install contract dependencies
cd contracts
npm install

# Install frontend dependencies
cd frontend
npm install
```

3. Environment setup
```bash
cp .env.example .env.local
# Add environment variables
```

4. Start development server
```bash
npm run dev
```

## 🧪 Testing

```bash
# Smart contract tests
npx hardhat test

# Frontend tests
npm run test
```

## 📝 Contract Integration

```javascript
import { useContract, useContractWrite } from "@thirdweb-dev/react";

// Use contract hook
const { contract } = useContract("YOUR_CONTRACT_ADDRESS");

// Create campaign
const { mutate: createCampaign, isLoading } = useContractWrite(
  contract,
  "createCampaign"
);
```

## 🔐 Security Features

- Multi-signature wallet support
- Contract pausability
- Access control modifiers
- Secure fund management
- Input validation

## 📜 License

MIT License. See [LICENSE](LICENSE) for more information.

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Submit Pull Request

## ✍️ Author

[Your Name]

## 📧 Contact

[Your Contact Information]