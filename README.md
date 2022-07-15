```
eip: <to be assigned>
title: ERC: Content Attestation Registry
author: David Ammouial (@davux) <dammouia@everis.com>
discussions-to: <URL>
status: Draft
type: Standards Track
category: ERC
created: 2019-03-29
```

## Simple Summary
A generic and privacy-aware registry of attested information.

## Abstract
This ERC describes a way for any entity to express and record its agreement with a given content, independently from the type of content, by storing a hash on chain along with a validity time range. Even though the existence of the agreement itself is provable and non-ambiguous, this specification doesn't place any semantics on the type of original content, how it's hashed, or what it means to agree with it. Likewise, it doesn't define any recommendation on the semantic validity of an attestation in relation to its recorded time range. As with any kind of recorded agreement, it is generally a good idea for the involved parties to ensure a mutual understanding on what is agreed upon and to what extent.

This ERC also allows the agreeing party to amend a previously recorded attestation by redefining the validity time range (including retracting the attestation altogether).

## Motivation
Traditionally, attesting to some kind of content is done through static signatures, e.g. a base64-encoded embedded RSA signature or a PGP signature. As for the smart contract world, hashes are often used in functions to certify content approval but no stable interface has been defined. This EIP is an attempt to homogenize a common interface for agreement that interoperable contract-based and web-based applications may start benefitting from.

Also, traditional signatures, in order to be retracted or amended, need to be put in context of Certificate Revocation Lists (CRLs) or similar mechanisms. This EIP attempts to leverage blockchain technology to remove the need for such centralized databases.

## Definitions

**Attester**

The attester of a given content is any entity, represented by an Ethereum address, that records its agreement with that content.

**Attestation**

In this specification, an attestation is defined as a (start time, end time) tuple that represents the time range during which a content is agreed upon by a specific attester.

**Verifier**

The verifier of an attestation is an entity going through the process of reading an attestation for a given content and making conclusions on whether to trust that content.

## Specification

The general idea of this EIP is that attesting a given content is equivalent to attesting a hash of that content, as long as the hashing function is known by the attester and the verifier.

An attestation is recorded as an `(iat, exp)` tuple, where `iat` ("issued at") is the time the attestation starts to be valid, and `exp` ("expires") is the time after which the attestation is no longer valid.

Note the special meaning of the following values:

- `iat == 0` means the attester is NOT currently attesting to that content. In this case, the value of `exp` is irrelevant. Per Solidity rules, this is the initial value for any attestation. Its intended usage inside the `attest()` function is to explicitly revoke an existing (i.e. non-zero `iat`) attestation.
- `exp == 0` means the attester is not currently placing any expiration time on the attestation. Just like any other value, a value of `0` may be amended later if the attester decides so.

This EIP defines the following functions:

**attest**

Used in a transaction to record an `(iat, exp)` attestation of a given hash.

```js
 function attest(bytes32 hash, uint iat, uint exp) public;
```

**attestations**

Used to read the most recent attestation, if any, of a given `hash`, recorded by a given `attester`. Its return value is an `(iat, exp)` tuple.

```js
function attestations(bytes32 hash, address attester) public;
```

This EIP defines the following event:

**Attested**

This event is emitted everytime a `hash` is attested or revoked by an `attester` and contains the `iat` and `exp` times of the attestation. A value of `0` for `iat` means any previous attestation is being revoked. The event may be emitted with any values for `iat` and `exp`, including values equal to the previous ones (for example an already revoked attestation may be revoked again, or an attestation may be attested again with the same values).

```js
event Attested(bytes32 indexed hash, address attester, uint iat, uint exp);
```

## Note about validity times

The validity time range is a mere indication by the attester. This EIP does not define what policy should be applied by verifying software or people with respect to current time. Here are a few real-life policy examples:

- **Safe policy**. Some verifiers might decide that an attestation is only acceptable if the expiration time is at least 6 months in the future.
- **Flexible policy**. Some verifiers might leave a tolerance window during which they still accept an expired attestation.
- **Strict policy**. Some verifiers might only accept an attestation during the attestation time range.
- Some verifiers might apply more complex policies, e.g. where the tolerance depends on the identity of the attester, on the content, on the actual transaction time of the attestation, on the existence of previous attestations, etc.

## Rationale

### Storing validity times on-chain vs. off-chain
Information stored on a blockchain is both public and permanent, which makes it a crucial decision to decide what to store and what not to store. For this reason, a balance should always be seeked between privacy and usefulness. Specifically, the decision to include validity times on chain rather than in the original content is a result of that subjective balance:

- Including validity times means leaking out information allowing to suspect or discard specific contents for a given hash. For example, time ranges of 3 weeks might give up certain types of documents, and exclude e.g. passports.
- Leaving validity times off-chain (typically in the original document) might not work very well for some types of documents where the issuer and the attester are separate entities and the attester doesn't have the liberty to emit an "attestation document" containing validity times.

This specification allows verifiers to store date information on-chain. However, the attester and the verifier are always free to use any non-zero value in the `(iat, exp)` tuple and maintain date information off-chain instead.

### Attesting hashes vs. plain data
To follow best practices, it was deemed equally secure, cheaper, and most respectful to privacy to record fixed-length `bytes32` data rather than actual content.

## Backwards Compatibility
This EIP doesn't introduce any known backwards compatibility issues.

## Implementation
An implementation may be found [here](https://gitlab.com/KayTrust/developer/blob/master/contracts/AttestationRegistry.sol).

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
