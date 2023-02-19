pragma solidity 0.8.2;

contract DigitalPassport {
    
    struct Passport {
        uint256 tokenId;
        address[] ownershipHistory;
        uint productId;
        uint[] historyTimestamps;
        uint expiryDate;
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

    }
    
    function retrieve(uint256 _tokenId) public view returns (uint256, address[] memory, uint, uint[] memory, uint) {
        Passport memory passport = passports[_tokenId];
        return (passport.tokenId, passport.ownershipHistory, passport.productId, passport.historyTimestamps, passport.expiryDate);
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

}
