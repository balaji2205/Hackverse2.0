pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public players;
    address payable public winner;
    event NumberSet(address indexed winner);

    constructor(){
        manager=msg.sender;
      
    }

    function participate(address sender) public payable{
        require(msg.value>=1 ether,"Please pay minimum 1 ether");
        players.push(payable(sender));
    }

    function getBalance() public view returns(uint){
        require(manager==msg.sender,"You are not the manager");
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        require(manager==msg.sender,"You are not the Manager");
        require(players.length>=2,"Players are less than 3");
        uint r=random();
        uint index= r%players.length;
        winner=players[index];
        winner.transfer(getBalance());
        players= new address payable[](0);
        emit NumberSet(winner);
    }
}