pragma solidity ^0.5.16;
import "./MultiOwned.sol";

contract Proxy is MultiOwned {
    
  event Forwarded (address indexed destination, uint value, bytes data);
  event Initialized(address indexed id);
  event Upgraded(address indexed oldId, address indexed newId);
  event Received (address indexed sender, uint value);

  // ABI location (preferably with sorted keys and no whitespaces)
  string public ABI_URL = "QmVxySamqhbFcFrJDYE9c5ag941dPoSxvffFUqTP6BTGzY";

  // The user's Id contract
  address public id = address(0);

  constructor(address firstOwner) MultiOwned(firstOwner) public {}

  function () external payable { emit Received(msg.sender, msg.value); }

  function forward(address destination, uint value, bytes memory data) public onlyOwner {
    (bool success, bytes memory returnData) = destination.call.value(value)(data);
    require(success, string(returnData));
    emit Forwarded(destination, value, data);
  }

  function setId(address newId) public onlyOwner {
    emit Upgraded(id, newId);
    id = newId;
  }
  
}