import axios from 'axios';

import { ethers } from 'ethers';
import { config } from 'dotenv';
import { getSafeAPI } from './constants';

config();
export async function signHash(hash: string) {
  let signingKey = new ethers.utils.SigningKey(process.env.PRIVATE_KEY.toString());
  var signature = signingKey.signDigest(hash);
  console.log('');
  console.log('Signature from the delegate of the new contract transaction hash');
  const result = ethers.utils.joinSignature(signature);
  console.log(result);
  console.log('');
  return result;
}

export const gnosisEstimateTransaction = async (safe: string, chainId: number, tx: any): Promise<any> => {
  const safeAPI = getSafeAPI(chainId);
  try {
    const resp = await axios.post(`${safeAPI}/safes/${safe}/multisig-transactions/estimations/`, tx);
    console.log('');
    return resp.data;
  } catch (e) {
    console.log('');
    console.log('There has been an error estimating the transaction');
    console.log('');
    if (e.response) console.log(JSON.stringify(e.response.data));
    throw e;
  }
};

export const gnosisEstimateNonce = async (safe: string, chainId: number): Promise<any> => {
  const safeAPI = getSafeAPI(chainId);
  try {
    const resp = await axios.post(`${safeAPI}/safes/${safe}`);
    return resp.data;
  } catch (e) {
    console.log('');
    console.log('There has been an error estimating the nonce');
    console.log('');
    console.log(JSON.stringify(e.response.data));
    throw e;
  }
};

export const gnosisProposeTx = async (safe: string, chainId: number, tx: any): Promise<any> => {
  const safeAPI = getSafeAPI(chainId);
  try {
    const resp = await axios.post(`${safeAPI}/safes/${safe}/multisig-transactions/`, tx);
    console.log(resp.data);
    return resp.data;
  } catch (e) {
    console.log('');
    console.log('There has been an error proposing the transaction, trying again with a new contract hash');
    console.log('');
    // console.log(e)
    if (e.response) {
      console.log(e.response.data);
      const newContractTxHash = e.response.data.nonFieldErrors[0].substr(26, 66);
      console.log('New contract transaction hash');
      console.log(newContractTxHash);
      const newTx = tx;
      newTx.contractTransactionHash = newContractTxHash;
      const signature = await signHash(newContractTxHash);
      newTx.signature = signature;
      try {
        const resp2 = await axios.post(`${safeAPI}/safes/${safe}/multisig-transactions/`, newTx);
        console.log('Success, transaction sent!');
        console.log('Data sent to Gnosis:');
        console.log(newTx);
        return resp2.data;
      } catch (f) {
        console.log('');
        console.log('There has been an error on the second try');
        console.log('');
        console.log(JSON.stringify(f.response.data));
        throw f;
      }
    }
  }
};

