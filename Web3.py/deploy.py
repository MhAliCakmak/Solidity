from solcx import compile_standard, install_solc
import json
from web3 import Web3
from dotenv import load_dotenv 
import os

load_dotenv()

with open("../SampleProject/SimpleStorage.sol","r") as files:
    simple_storage_files=files.read()
    

#Complie Our Solidity

compiled_sol = compile_standard(
    {
    "language":"Solidity",
    "sources": {"SimpleStorage.sol":{"content":simple_storage_files}},
    "settings" :{
        "outputSelection":{
            "*" :{"*":["abi","metadata","evm.bytecode","evm.sourceMap"]}
        }
    },
    },
    solc_version="0.8.0",
)

with open("compiled_code.json","w") as files:
    json.dump(compiled_sol,files)

#get bytecode 
bytecode= compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

#get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]

# for connecting to ganache
w3=Web3(Web3.HTTPProvider("https://0.0.0.:8545"))
chain_id=1337
my_address = "0xBCFdd6639E642EAb113558bED1AFbF016C4F65d3"
private_key=os.environ["PRIVATE_KEY"]

#Create the contract in python
SimpleStorage=w3.eth.contract(abi=abi,bytecode=bytecode)
# Get the latest transcation
nonce=w3.eth.getTransactionCount(my_address)


transaction= SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce":nonce
    }
)

signed_txn=w3.eth.account.sign_transaction(transaction,private_key=private_key)
#Send this signed transaction
tx_hash=w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt=w3.eth.wait_for_transaction_receipt(tx_hash)