# KayTrust Digital Identity components

## What is Digital Identity?

Identity refers to 2 things:

- **Identifiers**, i.e. unique and non-ambiguous strings used to _refer_ to people, organizations, vehicles, building, etc. An email address, a phone number, a national ID number, a nickname or a physical address are all identifiers within a certain system.
- **Claims**, i.e. _what_ is said about those entities. It's also usually important to consider _who_ says those things. For example "Individual with ID number 123 can drive" is useless without the information (and proof) of who claims it – typically a government entity. A set of claims, packed along with an issuing entity's identifier and a way to verify the whole thing, is called a **credential**.

## What is Self-Sovereign digital identity?

It is important to understand the vision behind self-sovereign identity: **nobody (no company, not any government, etc.) may control, block, censure, delete or spoof users' identity, restrict what users may do with their identity, or access information that users didn't agree to share.**

KayTrust achieves that by using a **decentralised trust repository** (typically a blockchain) for identifiers, for credential proofs, and for sharing consent. The repository itself only stores proofs of data integrity. No private information is stored on the shared repository, so KayTrust works on public repositories such as public blockchains.


## What is KayTrust?
At its base layer, KayTrust is an open-source set of specifications around digital identity. Those specifications build on top of existing Internet standards whenever they're available.

There is also a free mobile app called KayTrust Wallet that is available for free [on Google's Play Store](https://play.google.com/store/apps/details?id=com.everis.mytrust.app) and [on Apple's App Store](https://apps.apple.com/app/mytrust-wallet/id1477073898). That app lets you hold verifiable credentials and manage your decentralized digital identities.

(As a side note: if you're a large company and you need consulting services, [NTT DATA](https://nttdata.com/) licenses ready-to-use applications, microservices and an SDK that use these specifications. You can find more information about those commercial products on [KayTrust commercial website](https://www.kaytrust.id/).)

## Specifications

### DIDs

KayTrust uses the standard DID protocol for identifiers, and defines an ["EV" DID method](/KayTrust/did-method-ev) based on [smart contracts](https://developer.kaytrust.id/Specs/Proxy-Contract-ERC).

| Specification                                  | Builds on top of        | What is it good for?
| ---------------------------------------------- | ----------------------- | --------------------
| ["ev" DID method](/KayTrust/did-method-ev)      | W3C's DID Specification | Ethereum-based DIDs
| [Proxy contract ERC](https://developer.kaytrust.id/Specs/Proxy-Contract-ERC) ([code](/KayTrust/did-method-ev/contracts/Proxy.sol))| Ethereum                | Transaction forwarding, on-chain representation, single Ethereum addresses
| Identity Manager ERC  ([code](/KayTrust/did-method-ev/contracts/IdentityManager.sol))                          | Ethereum                | Flexible controlling logic for Proxy contracts

### Verifiable credentials and Presentations

Besides identifiers, the point of an identity is to have credentials associated to it. A credential answers the question *"Who are you?"* and contains one or more key-value claims (e.g. birth date, name, qualifications, citizenships, etc.) about an entity called subject, issued by another entity called issuer. The Verifiable Credentials Working Group at the W3C is defining a standard that KayTrust follows.

Both Verifiable Credentials (VC) and Verifiable Presentations (VP) contain proofs, which is what makes them verifiable. The VC specification doesn't enforce a specific proof algorithm but describes the articulation between a credential/presentation and a specific proof method. Implementers are free to come up with their own proof method or to follow someone else's.

The [draft ERC](https://developer.kaytrust.id/Specs/Content-Attestation-Registry-ERC) (Ethereum Request for Comments) describes a way for any entity to attest arbitrary content on a smart contract. There is a corresponding [proof type](https://developer.kaytrust.id/Specs/Ethereum-Attestation-Registry-Proof-Type) that enables to use that attestation registry inside a Verifiable Credential or a Verifiable Presentation.

| Specification                                                         | Builds on top of        | What is it good for?
| --------------------------------------------------------------------- | ----------------------- | --------------------
| [Content Attestation Registry ERC](https://developer.kaytrust.id/Specs/Content-Attestation-Registry-ERC) ([code](/KayTrust/id/contracts/verificationRegistry/VerificationRegistry.sol))  | Ethereum                | Attesting any kind of content on-chain
| [Attestation Registry VC proof type](https://developer.kaytrust.id/Specs/Ethereum-Attestation-Registry-Proof-Type) | W3C's Verifiable Credentials Specification | Using a Content Attestation Registry as proof of a VC or a VP

### Decentralized SSO: _DID Connect_

KayTrust introduces a way for identity owners (a.k.a. subjects) to authenticate on third-party apps. We propose using OpenID Connect, only in a self-sovereign fashion. The trick is to use as Authorization Server the identity owner's own device, as opposed to a predefined AS in traditional services.

| Specification                         | Builds on top of | What is it good for?
| ------------------------------------- | ---------------- | ------------------------------------
| [DIDConnect OIDC Profile](/KayTrust/did-connect) | OpenID Connect   | Self-sovereign use of OpenID Connect

### Schemas

KayTrust mostly relies on well-known schemas, such as the great work done by the schema.org community. However, when the need arises, additional schemas are defined.

| Schema                                            | Purpose
| ------------------------------------------------- | --------------------------------------------------
| [Trusted Credentials](https://developer.kaytrust.id/Specs/Trusted-Credentials) | Chain of Trust for Verifiable Credentials
