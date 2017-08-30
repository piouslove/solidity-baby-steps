// 合约可以在其他合约里面得到非常量的函数返回值（而在 web3/geth 中则不行）
// Contracts can get non-constant return values from functions in other contracts. (Whereas you can't from web3/geth.)
// 以下用两个合约测试一下
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong with a pongval. 先传入pongval值部署Pong合约，也就是Pong合约有pongval值
// 2. Deploy Ping, giving it the address of Pong. 部署Ping合约，并把Pong的地址发送给它
// 3. Call Ping.getPongvalRemote() using a sendTransaction... 用一个交易调用Ping.getPongvalRemote()函数
// 4. ... which retreives the value of pongval from Pong. Ping从Pong合约取回pongval值
// 5. If successful Ping.getPongval() should return the value from step 1. 如果成功Ping.getPongval()应该返回步骤1的值

contract PongvalRetriever {
 	int8 pongval_tx_retrieval_attempted = 0;
	function getPongvalTransactional() public returns (int8){	// tells Ping how to interact with Pong.
		pongval_tx_retrieval_attempted = -1;
		return pongval_tx_retrieval_attempted;
	}
}

contract Ping is PongvalRetriever {

 	int8 pongval;
	PongvalRetriever pvr;
    address creator;

	/*********
 	 Step 2: Deploy Ping, giving it the address of Pong.
 	 *********/
    function Ping(PongvalRetriever _pongAddress) 
    {
        creator = msg.sender; 	
        pongval = -1;							
        pvr = _pongAddress;
    }

	/*********
     Step 3: Transactionally retrieve pongval from Pong. 
     *********/

	function getPongvalRemote() 
	{
		pongval = pvr.getPongvalTransactional();
	}
	
	/*********
     Step 5: Get pongval (which was previously retrieved from Pong via transaction)
     *********/
     
    function getPongvalConstant() constant returns (int8)
    {
    	return pongval;
    }
	
  
// -----------------------------------------------------------------------------------------------------------------	
	
	/*********
     Functions to get and set pongAddress just in case
     *********/
    
    function setPongAddress(PongvalRetriever _pongAddress)
	{
		pvr = _pongAddress;
	}
	
	function getPongAddress() constant returns (address)
	{
		return pvr;
	}
    
    /****
	 For double-checking this contract's address
	 ****/
	function getAddress() returns (address)
	{
		return this;
	}
    
    /*********
     Standard kill() function to recover funds 
     *********/
    
    function kill()
    { 
        if (msg.sender == creator)
            suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}

// See Pong for deployment/use. 
