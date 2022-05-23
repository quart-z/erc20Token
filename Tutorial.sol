// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


abstract contract ERC20 {
    
    // Returns the total supply of the token
    function totalSupply() virtual public view returns (uint);
    
    // Returns account balance with address 'tokenOwner'
    function balanceOf(address tokenOwner) virtual public view returns (uint balance); 
    
    // Returns amount 'spender' can withdraw from 'tokenOwner'
    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
    
    // Transfers 'tokens' amount to address 'to'. Fires Transfer event which can potentially throw error if balance too low.
    function transfer(address to, uint tokens) virtual public returns (bool success); 
    
    // Lets 'spender' withdraw from an account multiple times, up to the amount 'tokens'
    function approve(address spender, uint tokens) virtual public returns (bool success);

    // Transfers 'tokens' amount from address 'from' to address 'to'. Fires Transfer event which can potentially throw error if balance too low.
    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
    
    
    // EVENTS
    
    // Triggers when tokens are transferred. This includes zero value transfers.
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    // Triggers on a successful call to approve function
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Tutorial is ERC20 {
    
    function totalSupply() public override view returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public override view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // EVENTS

    function transfer(address receiver, uint tokens) public override returns (bool success) {
        balances[msg.sender] = (balances[msg.sender] - tokens);
        balances[receiver] = (balances[receiver] + tokens);
        emit Transfer(msg.sender, receiver, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address sender, address receiver, uint tokens) public override returns (bool success) {
        balances[sender] = (balances[sender] - tokens);
        allowed[sender][msg.sender] = (allowed[sender][msg.sender] - tokens);
        balances[receiver] = (balances[receiver] + tokens);
        emit Transfer(sender, receiver, tokens);
        return true;
    }

    string public constant name = "Tutorial"; // Change
    string public symbol = "TUT"; // Change
    uint256 _totalSupply = 1000000 ether; // Change
    uint8 public decimals = 18; 

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    constructor() {
        balances[msg.sender] = _totalSupply;
    }
    
    
}
