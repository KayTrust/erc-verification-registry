pragma solidity ^0.5.16;

contract ClaimAttester {
  event ClaimAttested(bytes32 indexed sourceClaimHash, bytes32 indexed targetClaimHash, address attester, uint256 date, uint256 expDate);
  event ClaimRevoked(bytes32 indexed sourceClaimHash, bytes32 indexed targetClaimHash, address attester, uint256 date);

  struct Attestation {
    // Attestation date (0 means "not attested")
    uint iat;
    // Attestation expiration date (0 means "never expires")
    uint exp;
  }

  // subjectHash  => claimHash => attester => Attestation
  mapping (bytes32 => mapping (bytes32 => mapping (address => Attestation))) attestations;

  function attestClaim(bytes32 subjectHash, bytes32 claimHash, address attester, uint validDays) public {
    uint exp = validDays > 0 ? now + validDays * 1 days : 0;
    attestations[subjectHash][claimHash][attester] = Attestation(now, exp);
    emit ClaimAttested(subjectHash, claimHash, attester, now, exp);
  }

  function revokeClaim(bytes32 subjectHash, bytes32 claimHash, address attester) public {
    attestations[subjectHash][claimHash][attester] = Attestation(0, now);
    emit ClaimRevoked(subjectHash, claimHash, attester, now);
  }
}
