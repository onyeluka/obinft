  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.9;
  import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "./IWhitelist.sol";

contract PeterObi is ERC721Enumerable, Ownable{
string _baseTokenURI;
uint256 public _price = 0.35 ether;
bool public _paused;
uint256 public maxTokenIds = 4000;
uint256 public tokenIds;
IWhitelist whitelist;
bool public presaleStarted;
uint256 public presaleEnded;
modifier onlyWhenNotPaused{
    require(!_paused, "Contract currently paused");
     _;
}
constructor(string memory baseURI, address whitelistContract) ERC721("PeterObi", "PetObi") {
_baseTokenURI = baseURI;
whitelist = IWhitelist(whitelistContract);
}
//starts presale for all whitelisted addresses
function startPresale() public onlyOwner{
    presaleStarted = true;
    presaleEnded = block.timestamp + 5 minutes;
}
// allows only one NFT per transaction at presale
function presaleMint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
    require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted" );
    require(tokenIds < maxTokenIds, "Exceeded maximum Peter Obi supply");
    require(msg.value >= _price, "Ether sent is not correct");
    tokenIds += 1;
    _safeMint(msg.sender,tokenIds);

}
//allows user to mint after presaleEnded
function mint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet");
    require(tokenIds < maxTokenIds, "Exceed maximium Peter Obi Supply");
    require(msg.value >= _price, "Ether sent is not correct");
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
}
function  _baseURI() internal view virtual override returns (string memory){
    return _baseTokenURI;
} 
function setPaused(bool val) public onlyOwner{
    _paused = val;
}
function withdraw() public onlyOwner{
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent, ) = _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
}
receive() external payable{}
fallback() external payable{}
}
