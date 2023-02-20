// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

contract DigitalPassport {
    
    struct Passport {
        uint256 tokenId;
        address[] ownershipHistory;
        uint productId;
        uint[] historyTimestamps;
        uint expiryDate;
        address[] delegates;
    }
    
    mapping(uint256 => Passport) private passports;
    
    function register(uint256 _tokenId, address _ownershipHistory, uint _productId, uint _expiryDate) public {
        require(_productId != 0, "Error: Product ID cannot be zero!");
        require(passports[_tokenId].productId == 0, "Error: Token already exists with the same Token ID!");
        passports[_tokenId].tokenId =  _tokenId;
        passports[_tokenId].productId = _productId;
        passports[_tokenId].expiryDate = _expiryDate;
        uint[] memory timeArray = new uint[](1);
        timeArray[0] = block.timestamp;
        address[] memory addArray = new address[](1);
        addArray[0] = _ownershipHistory;
        passports[_tokenId].ownershipHistory = addArray;
        passports[_tokenId].historyTimestamps = timeArray;
        passports[_tokenId].delegates = new address[](0);
    }
    
    function retrieve(uint256 _tokenId) public view returns (uint256, address[] memory, uint, uint[] memory, uint, address[] memory) {
        require(passports[_tokenId].productId != 0, "Error: No Token found!");
        Passport memory passport = passports[_tokenId];
        return (passport.tokenId, passport.ownershipHistory, passport.productId, passport.historyTimestamps, passport.expiryDate, passport.delegates);
    }

    function addDelegates(address _delegate, uint256 _tokenId) public {
        require(passports[_tokenId].productId != 0, "Error: No Token found!");
        Passport storage passport = passports[_tokenId];
        passport.delegates.push(_delegate);
    }

    function transferToken(uint256 _tokenId, address _newOwner) public {
        require(block.timestamp < passports[_tokenId].expiryDate, "Error: Token expired! Cannot be transferred");
        uint i = 0;
        address[] memory addArray = new address[](passports[_tokenId].ownershipHistory.length + 1);
        for(i = 0; i < passports[_tokenId].ownershipHistory.length; i++){
            addArray[i] = passports[_tokenId].ownershipHistory[i];
        }
        addArray[i] = _newOwner;
        passports[_tokenId].ownershipHistory = addArray;
        uint[] memory timeArray = new uint[](passports[_tokenId].historyTimestamps.length + 1);
        uint j=0;
        for(j=0; j<passports[_tokenId].historyTimestamps.length; j++){
            timeArray[j]=passports[_tokenId].historyTimestamps[j];
        }
        timeArray[j]=block.timestamp;
        passports[_tokenId].historyTimestamps = timeArray;

    }

    function modifyExpiry(uint256 _tokenId, uint _newexpiry) public{
        require(passports[_tokenId].productId != 0, "Error: No Token found!");
        passports[_tokenId].expiryDate = _newexpiry;
    }

}
