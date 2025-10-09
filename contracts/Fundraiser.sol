// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// ----------------------
// Imports
// ----------------------
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
// ----------------------
// Contract
// ----------------------
contract Milestone is Ownable, ReentrancyGuard, Pausable {}
