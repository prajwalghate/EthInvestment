// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Owner
 * @dev Set & change owner
 */
contract InterestContract {

    address  public owner ;

    enum InvestmentState {
        HOLDING,
        DISPATCHED
    }

    struct Investment {
        address payable invester;
        uint amount;
        InvestmentState state;
        uint rate;
        uint time;
        uint investmentdate;
    }

    Investment[] public investementList;

    mapping (address=>uint[]) public investmentMap;

    
    constructor ()  {
        owner = msg.sender;
        
    }

    function newInvestment (uint _amount ,uint _rate,uint _time ) payable public {
        require(msg.sender.balance >= _amount);
        investementList.push(Investment(payable(msg.sender),_amount ,InvestmentState.HOLDING,_rate,_time,block.timestamp));
        investmentMap[msg.sender].push(investementList.length-1);   
        deposit(_amount);  
    }

    function getReturn (uint index,uint _days) payable public {
        uint investmentId=investmentMap[msg.sender][index];
        if(investementList[investmentId].state==InvestmentState.HOLDING){
            if(block.timestamp >= (investementList[investmentId].investmentdate + investementList[investmentId].time + _days*1 days)){
            uint ret=investementList[investmentId].amount*(1 + (investementList[investmentId].rate/100)*investementList[investmentId].time);
            withdraw(ret);
            }else{
                withdraw(investementList[investmentId].amount);
            }
        }
    } 

    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        payable(owner).transfer(msg.value);
    }

    function withdraw(uint256 amount) public {
        payable(msg.sender).transfer(amount);
    
    }   

}
