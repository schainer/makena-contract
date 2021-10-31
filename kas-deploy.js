require('dotenv').config();
const Caver = require('caver-js');
const fs = require('fs');
const path = require('path');
const abiSource = process.argv.slice(2)[0];

const kasCredentials = {
  chainId: '1001',
  accessKey: process.env.KAS_ACCESS_KEY,
  secretKey: process.env.KAS_SECRET_KEY,
};
const option = {
  headers: [
    {
      name: 'Authorization',
      value:
        'Basic ' +
        Buffer.from(
          kasCredentials.accessKey + ':' + kasCredentials.secretKey
        ).toString('base64'),
    },
    { name: 'x-chain-id', value: '1001' },
  ],
  keepAlive: false,
};

const caver = new Caver(
  new Caver.providers.HttpProvider(
    `https://node-api.klaytnapi.com/v1/klaytn`,
    option
  )
);

console.log(path.join(__dirname, abiSource));
const pathName = path.join(__dirname, abiSource);
fs.readFile(pathName, async (err, data) => {
  if (err) {
    console.log('file not found!', err);
    process.exit(1);
  }
  const compiledContract = require(path.join(__dirname, abiSource));
  const abi = compiledContract.abi;
  const bytecode = compiledContract.bytecode;
  // Opensea Proxy Main: "0xa5409ec958c83c3f309868babaca7c86dcb077c1"
  // Opensea Proxy Baobab: "0xf57b2c51ded3a29e6891aba85459d600256cf317"
  const initArgs = [
    'Color',
    'CNFT',
    'https://baobab.scope.klaytn.com/',
    'https://baobab.scope.klaytn.com/',
    caver.utils.toPeb('0.2', 'KLAY'),
    1,
    '0xf57b2c51ded3a29e6891aba85459d600256cf317',
  ];

  const deploymentByteCode = caver.abi.encodeContractDeploy(
    abi,
    bytecode,
    ...initArgs
  );
  const transaction = caver.transaction.smartContractDeploy.create({
    from: process.env.DEPLOYER_ADDRESS,
    input: deploymentByteCode,
    gas: '10000000',
  });
  const signedTransaction = await transaction.sign(process.env.DEPLOYER_SECRET);
  const rlpEncodedValue = await signedTransaction.getRLPEncoding();

  try {
    const txResult = await caver.rpc.klay.sendRawTransaction(rlpEncodedValue);
    console.log(`Deployed: ${abiSource}`);
    console.log(txResult);
  } catch (err) {
    console.log(err);
  }
});
