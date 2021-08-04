// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MultiOwned is Initializable {
  event OwnerAdded(address indexed newOwner);
  event OwnerRemoved(address indexed formerOwner);
  mapping (address => bool) public owners;
  modifier onlyOwner() {
    require(isOwner(msg.sender));
    _;
  }
  
  function __multiOwnedInit(address newOwner) initializer internal {
      owners[newOwner] = true;
      //emit OwnerAdded(newOwner);
  }

  function isOwner(address addr) public view returns(bool) {
    return owners[addr];
  }

  function addOwner(address newOwner) public onlyOwner {
    owners[newOwner] = true;
    emit OwnerAdded(newOwner);
  }

  function renounce() public onlyOwner {
    owners[msg.sender] = false;
    emit OwnerRemoved(msg.sender);
  }
  
}