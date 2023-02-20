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
    
    mapping(uint256 => Passport) public passports;
    
    function register(uint256 _tokenId, address _ownershipHistory, uint _productId, uint _expiryDate) public {
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
        Passport memory passport = passports[_tokenId];
        return (passport.tokenId, passport.ownershipHistory, passport.productId, passport.historyTimestamps, passport.expiryDate, passport.delegates);
    }

    function addDelegates(address _delegate, uint256 _tokenId) public {
        Passport storage passport = passports[_tokenId];
        passport.delegates.push(_delegate);
    }

    function transferToken(uint256 _tokenId, address _newOwner) public {
        uint i = 0;
        address[] memory addArray = new address[](passports[_tokenId].ownershipHistory.length + 1);
        for(i = 0; i < passports[_tokenId].ownershipHistory.length; i++){
            addArray[i] = passports[_tokenId].ownershipHistory[i];
        }
        addArray[i] = _newOwner;
        passports[_tokenId].ownershipHistory = addArray;
    }

    function clearOneDelegate(uint256 _tokenId, address _delegate) public {
        Passport storage passport = passports[_tokenId];

        for (uint i = 0; i < passport.delegates.length; i++) {
            if (passport.delegates[i] == _delegate) {
                if (passport.delegates.length == 1) {
                    passport.delegates.pop();
                } else if (i == passport.delegates.length - 1) {
                    passport.delegates.pop();
                } else {
                    passport.delegates[i] = passport.delegates[passport.delegates.length - 1];
                    passport.delegates.pop();
                }
                break;
            }
        }
    }


    function clearAllDelegates(uint256 _tokenId) public {
        Passport storage passport = passports[_tokenId];
        delete passport.delegates;
    }

}