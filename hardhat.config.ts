import { HardhatUserConfig } from "hardhat/config";
import * as dotenv from "dotenv";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();



const blockscannerAPI = (network: string) => {
  if (network == "mumbai" || network == "polygon") {
    return  process.env.POLYGONSCAN_API_KEY
  } else if (network == "arbitrum" || network == "arbitrumGoerli") {
    return process.env.ARBISCAN_API_KEY
  } else {
    return process.env.ETHERSCAN_API_KEY
  }
}

const network = "hardhat"
const config: HardhatUserConfig = {
  solidity: "0.8.9",
  defaultNetwork: network,
  networks: {
    localhost: {
      accounts: [process.env.ALICE_PRIVATE_KEY as string]
    },
    polygon: {
      url: process.env.POLYGON_RPC_ENDPOINT,
      accounts: [process.env.ALICE_PRIVATE_KEY as string]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
};

export default config;
