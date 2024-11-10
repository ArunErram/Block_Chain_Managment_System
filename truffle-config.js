module.exports = {
  contracts_build_directory: './client/src/artifacts',
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      gas: 6721975,
      gasPrice: 20000000000, // 20 gwei
    },
  },

  mocha: {
    timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.27", // Use a specific version instead of ^0.8.27
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "london" // Specify the EVM version
      }
    }
  },

  db: {
    enabled: false
  }
};