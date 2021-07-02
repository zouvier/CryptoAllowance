// SPDX-License-Identifier: GPL-3.0


//Made by ZOUVIER! 
// chose 0.8.0 because of the already implemented safe math, Also, i left some of the values as public for easy testing on Remix IDE. 
pragma solidity ^0.8.0;

contract SharedWallet {
    
    event Received(address, uint);
    
    // address of the owner, made it private so that it can only be accessed from within this contract.
    address private owner;
    
    // initialized owner variable.
    constructor()  payable{
        owner = msg.sender;
    }
    
    
    // created modifier for chekcing if address is the owner of the contract. 
    modifier IsOwner {
        require(msg.sender == owner, "Contact the owner of this Contract for assitance");
        _;
    }
    //check to see if address is able to withdraw weeklt allowance.
    modifier CheckCred {
        require(Trustee[msg.sender].can_withdraw == true && Trustee[msg.sender].timeUntilNextWithdraw < (block.timestamp), "Sorry you're either too early or no longer have access to this wallet");
        _;
    }

    
    // a struct that will keep track of an address ability to withdraw.
    struct AllowedWallet {
        bool can_withdraw;
        bool alreadySet;
        uint withdraw_Amount;
        uint timeUntilNextWithdraw;
    }
    
    // mapping to associate an address to the AllowedWallet struct which keeps track of the address's ability to withdraw. 
    mapping(address => AllowedWallet) Trustee;
    
    
    
    // function to initialize an address to the shared wallet. can only be done by the owner of the wallet. 
    // MAKE PRIVATE
    function addToTrustedListAndPay(address _trustedAddress, uint weeklyAmount) IsOwner external  {
        require(Trustee[_trustedAddress].alreadySet == false);
        Trustee[_trustedAddress].alreadySet = true;
        Trustee[_trustedAddress].timeUntilNextWithdraw = block.timestamp + 1 weeks;
        Trustee[_trustedAddress].can_withdraw = true;
        Trustee[_trustedAddress].withdraw_Amount = weeklyAmount;
        payable(_trustedAddress).transfer(Trustee[_trustedAddress].withdraw_Amount * (10**18)); 
        
    }
    
    //allow the owner of the contract to remove an address from the trusted list.
    // MAKE PRIVATE
    function removeFromTrustedList(address _trustedAddress) IsOwner external {
        require(Trustee[_trustedAddress].can_withdraw = false);
    }
    
    
    // allows an address to withdraw allowances again. adding them to the trusted list. 
    // MAKE PRIVATE
    function addAgain(address _trustedAddress) IsOwner external {
        require(Trustee[_trustedAddress].alreadySet == true);
        Trustee[_trustedAddress].timeUntilNextWithdraw = block.timestamp + 1 weeks;
        Trustee[_trustedAddress].can_withdraw = true;
    }
    
    
    // allow the caller to withdraw the amount that they're allowed for, CheckCred checks if the address has waited a week, and if they're allowed to recieve funds. 
    function collectWeeklyAllowance() external CheckCred payable{
        Trustee[msg.sender].timeUntilNextWithdraw = block.timestamp + 1 weeks;
        payable(msg.sender).transfer(Trustee[msg.sender].withdraw_Amount * (10**18));
    }
    
    
    //allows the owner to withdraw any amount they want
    // MAKE PRIVATE
    function ownerWithdraws(uint amount) IsOwner external payable {
        payable(owner).transfer(amount);
    }
    
    
    // allows the owner to check the value of the contract
    //MAKE PRIVATE
    function CheckAddressValue() view external IsOwner returns(uint) {
        return ((address(this).balance)/1 ether);
    }
    
    // fall back function so the wallet can recieve Eth. 
   fallback() external payable {
       emit Received(msg.sender, msg.value);
   }
   
   receive() external payable {  }

   
    
    
    
    
    }
