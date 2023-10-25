import { submit } from './utils/submitTx';
import transactionJson from '../scripts/foundry/transaction.json';

async function main() {
  const chainId = transactionJson['chainId'];
  console.log(transactionJson);
  const safeAddress = transactionJson['safe'];
  await submit(transactionJson, 0, chainId, safeAddress);
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});
