pragma solidity ^0.4.15;
import "./libs/MultiOwned.sol";

contract Proxy is MultiOwned {
  event Forwarded (address indexed destination, uint value, bytes data);
  event Initialized(address indexed id);
  event Upgraded(address indexed oldId, address indexed newId);
  event Received (address indexed sender, uint value);

  // ABI location (preferably with sorted keys and no whitespaces)
  string public ABI_URL = "ipfs:/QmcmKwPfMXE6a9feDYev7wiCEBQyt7cREFD5AvwDi5Z9sC";

  // The user's Id contract
  address public id = address(0);

  function Proxy(address firstOwner) MultiOwned(firstOwner) public {}

  function () public payable { Received(msg.sender, msg.value); }

  function forward(address destination, uint value, bytes data) public onlyOwner {
    require(destination.call.value(value)(data));
    Forwarded(destination, value, data);
  }

  function setId(address newId) public onlyOwner {
    Upgraded(id, newId);
    id = newId;
  }
}
