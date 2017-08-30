/* 
	The following is an extremely basic example of a solidity contract. 
	这是一个极其简单的solidity智能合约。
	It takes a string upon creation and then repeats it when greet() is called.
	它在创建时需要一个字符串，然后在调用greet（）时重复该字符串。
*/

contract Greeter         // 声明合约，构造函数为与其同名的函数function Greeter(string _greeting) public
{
    address creator;     // At first, an empty "address"-type variable of the name "creator". Will be set in the constructor.
    string greeting;     // At first, an empty "string"-type variable of the name "greeting". Will be set in constructor and can be changed.

    function Greeter(string _greeting) public   // 这就是同名的合约构造函数，此处这个函数接受一个字符串并赋值给greeting并保存它。
    {
        creator = msg.sender;
        greeting = _greeting;
    }

    function greet() constant returns (string)          
    {
        return greeting;
    }
    
    function getBlockNumber() constant returns (uint) // this doesn't have anything to do with the act of greeting
    {													// just demonstrating return of some global variableable
        return block.number;
    }
    
    function setGreeting(string _newgreeting) 
    {
        greeting = _newgreeting;
    }
    
     /**********
     Standard kill() function to recover funds 
     标准的kill()合约函数
     如果要停用合同，最好的方法是通过 disable 导致所有功能抛出的内部状态来禁用它们。最后的结果就是合约停用并且发送到合约的以太币自动退回
     **********/
    
    function kill()
    { 
        if (msg.sender == creator)  // 限定只有合创建者可以调用这个函数
            suicide(creator);       // 停用合约并且退回以太币
    }

}
