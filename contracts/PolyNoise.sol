//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//*
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

/*/
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

//*/

contract PolyNoise is ERC721, Ownable, ReentrancyGuard {
    // seed for the random noise
    uint16 randNonce = 0;
    // coutn minted
    uint16 public minted = 0;
    uint16 public totalSupply = 10000;
    uint256 public price = 0.01 ether;
    mapping(uint16 => uint256) public dna;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function _randMod(uint256 _modulus) internal returns (uint256) {
        // increase nonce
        randNonce++;
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function mint() external payable nonReentrant {
        require(msg.value == price, "Incorrect minting price.");
        require(minted < totalSupply, "Every token minted already.");

        dna[minted++] = _randMod(100000000);
        _safeMint(msg.sender, minted);

        bool sent;
        (sent, ) = owner().call{value: msg.value}("");
        require(sent, "Failed to send ether");
    }

    function batchMint(uint16 _amount) external payable nonReentrant {
        require(_amount > 1, "Use the simple mint function.");
        require(msg.value == price * _amount, "Incorrect minting price.");
        require(minted + _amount < totalSupply, "Every token minted already.");

        for (uint16 i = 0; i < _amount; i++) {
            dna[minted++] = _randMod(100000000);
            _safeMint(msg.sender, minted);
        }

        bool sent;
        (sent, ) = owner().call{value: msg.value}("");
        require(sent, "Failed to send ether");
    }

    function _baseURI() internal pure override returns (string memory) {
        return "linktometadataserver";
    }
}
