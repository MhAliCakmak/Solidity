const{expect}= require("chai");
const{ethers}=require("hardhat");
const provider =ethers.provider;

function ethToNum(eth) {
    return Number(ethers.utils.formatEther(eth));
}

describe("Lock Contract", function(){
    
    let owner,user1,user2;
    let Token,token;
    let Lock,lock;

    let balances;

    before(async function(){
        [owner,user1,user2]=await ethers.getSigners();
        
        Token=await ethers.getContractFactory("MASIToken");
        token=await Token.connect(owner).deploy();

        Lock=await ethers.getContractFactory("Lock");
        lock=await Lock.connect(owner).deploy(token.address);

        token.connect(owner).transfer(user1.address, ethers.utils.parseUnits("100", 18));
        token.connect(owner).transfer(user2.address, ethers.utils.parseEther("50"));

        token.connect(user1).approve(lock.address, ethers.constants.MaxUint256);
        token.connect(user2).approve(lock.address, ethers.constants.MaxUint256);
    });

    beforeEach(async function() {
        balances = [
            ethToNum(await token.balanceOf(owner.address)),
            ethToNum(await token.balanceOf(user1.address)),
            ethToNum(await token.balanceOf(user2.address)),
            ethToNum(await token.balanceOf(lock.address))
        ]
    });
    
    it("Deploys the contracts", async function() {
        expect(token.address).to.not.be.undefined;
        expect(lock.address).to.be.properAddress;
    });

    it("Sends tokens correctly", async function() {
        expect(balances[1]).to.be.equal(100);
        expect(balances[2]).to.be.equal(50);
        expect(balances[0]).to.be.greaterThan(balances[1]);
    });

    it("Approves tokens correctly", async function() {
        let allowances = [
            await token.allowance(user1.address, lock.address),
            await token.allowance(user2.address, lock.address),
        ]

        expect(allowances[0]).to.be.equal(ethers.constants.MaxUint256);
        expect(allowances[0]).to.be.equal(allowances[1]);
    });

    it("Reverts exceding transfer", async function() {
        await expect(token.connect(user1).transfer(lock.address, ethers.constants.MaxUint256)).to.be.reverted;
    });
    
    describe("Contract Functions", function(){
        
        let lockerCount=0;
        let totalLocked=0;
        let userLocks=[0,0];

        it("user1 locks tokens", async function(){
            
            totalLocked +=10;
            lockerCount++;
            userLocks[0]+=10;

            await lock.connect(user1).lockTokens(ethers.utils.parseEther("10"));

            expect(balances[3]+10).to.be.equal(ethToNum(await token.balanceOf(lock.address)));
            expect(balances[0]).to.be.equal(ethToNum(await lock.lockers(user1.address)));

        });
        
        it("Locker count and locked amount increase", async function(){
            except(lockerCount).to.be.equal(await lock.lockerCount());
            expect(totalLocked).to.be.equal(ethToNum(await lock.totalLocked()));
        });
        
        it("user2 cannot withdraw tokens", async function(){
            except(lock.connect(user2).witdrawToken).to.be.reverted;
        });

        it("user1 can withdraw tokens", async function(){
            totalLocked-=userLocks[0];
            userLocks[0]=0;
            await lock.connect(user1).witdrawToken();
            expect(balances[3]).to.be.equal(ethToNum(await token.balanceOf(lock.address)));
            expect(balances[0]).to.be.equal(ethToNum(await lock.lockers(user1.address)));

        });
          
    });
    
    it("prints timestamp", async function(){
    let blockNumber = await provider.getBlockNumber();
    let block= await provider.getBlock(blockNumber);
    console.log(block.timestamp);
    });
});
