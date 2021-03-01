pragma solidity ^0.4.15;

contract MultiOwned {
  event OwnerAdded(address indexed newOwner);
  event OwnerRemoved(address indexed formerOwner);
  mapping (address => bool) public owners;
  modifier onlyOwner() {
    require(isOwner(msg.sender));
    _;
  }

  function MultiOwned(address firstOwner) public {
    owners[firstOwner] = true;
    OwnerAdded(firstOwner);
  }

  function isOwner(address addr) public view returns(bool) {
    return owners[addr];
  }

  function addOwner(address newOwner) public onlyOwner {
    owners[newOwner] = true;
    OwnerAdded(newOwner);
  }

  function renounce() public onlyOwner {
    owners[msg.sender] = false;
    OwnerRemoved(msg.sender);
  }
}
