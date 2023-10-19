import { submit } from './utils/submitTx';
import transactionJson from '../scripts/foundry/transaction.json';
import { registry } from '@angleprotocol/sdk';

async function main() {
  const chainId = transactionJson['chainId'];
  console.log(transactionJson);
  const safeAddress = registry(chainId).Guardian;
  await submit(transactionJson, 0, chainId, safeAddress);
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});
