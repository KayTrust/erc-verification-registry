pragma solidity ^0.4.15;

contract Id {

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

  function setKey(bytes16 name, string url) onlyController {
    keys[name] = url;
    KeySet(name, url);
  }

  modifier onlyController {
    require(msg.sender == controller);
    _;
  }

  function Id(address _controller) {
    controller = _controller;
    ControllerSet(controller);
  }

  function setController(address _controller) {
    if (controller == address(0) || controller == msg.sender) {
      controller = _controller;
      ControllerSet(controller);
    } else {
      revert();
    }
  }

  function setMnemonic(bytes16 key, string username, string salt) onlyController {
    mnemonics[key] = AddressMnemonic(username, salt);
    MnemonicSet(username, msg.sender);
  }

  function setAdmin(address newAdmin) onlyController {
    AdminUpdated(admin, newAdmin);
    admin = newAdmin;
  }

  function setProfile(bytes16 name, string url) onlyController {
    profiles[name] = url;
    ProfileSet(name, url);
  }

  function shareInfo(string url, address with, bytes32 contentHash) onlyController {
    ConsentedShareInfo(url, with, contentHash);
  }
}
