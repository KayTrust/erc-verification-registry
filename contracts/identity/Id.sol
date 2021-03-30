pragma solidity ^0.5.16;
import "./ClaimAttester.sol";

contract Id is ClaimAttester {

  event ControllerSet(address controller);
  event ProfileSet(bytes16 name, string url);
  event KeySet(bytes16 indexed name, string url);
  event AdminUpdated(address oldAdmin, address newAdmin);
  event ConsentedShareInfo(string url, address indexed with, bytes32 indexed contentHash);
  event MnemonicSet(string indexed username, address from);

  address public controller;
  // The admin is checked off-contract to authorise certain actions
  address public admin = address(0);
  mapping (bytes16 => string) public profiles;
  mapping (bytes16 => string) public keys;

  // An address mnemonic is a simple note that allows to
  // retrieve a private key based on parameters. How those
  // parameters are to be used is at the user's discretion.
  struct AddressMnemonic {
    string username;
    string salt;
  }
  mapping (bytes16 => AddressMnemonic) public mnemonics;

  function setKey(bytes16 name, string memory url) public onlyController {
    keys[name] = url;
    emit KeySet(name, url);
  }

  modifier onlyController {
    require(msg.sender == controller);
    _;
  }

  constructor(address _controller) public {
    controller = _controller;
    emit ControllerSet(controller);
  }

  function setController(address _controller) public {
    require((controller == address(0) || controller == msg.sender), "controller cannot be the same as the sender");
    controller = _controller;
    emit ControllerSet(controller);
  }

  function setMnemonic(bytes16 key, string memory username, string memory salt) public onlyController {
    mnemonics[key] = AddressMnemonic(username, salt);
    emit MnemonicSet(username, msg.sender);
  }

  function setAdmin(address newAdmin) public onlyController {
    emit AdminUpdated(admin, newAdmin);
    admin = newAdmin;
  }

  function setProfile(bytes16 name, string memory url) public onlyController {
    profiles[name] = url;
    emit ProfileSet(name, url);
  }

  function shareInfo(string memory url, address with, bytes32 contentHash) public onlyController {
    emit ConsentedShareInfo(url, with, contentHash);
  }
}
