pragma solidity 0.8.2;

contract DigitalPassport {
    
    struct Passport {
        address tokenId;
        address[] ownershipHistory;
        uint productId;
        uint[] historyTimestamps;
        uint expiryDate;
    }
    
    mapping(address => Passport) private passports;
    
    function register(address _tokenId, address _ownershipHistory, uint _productId, uint _expiryDate) public {
        uint[] memory timeArray = new uint[](1);
        timeArray[0] = block.timestamp;

        address[] memory addArray = new address[](1);
        addArray[0] = _ownershipHistory;

        Passport memory newPassport = Passport({
            tokenId: _tokenId,
            ownershipHistory: addArray,
            productId: _productId,
            historyTimestamps: timeArray,
            expiryDate: _expiryDate
        });
        passports[_tokenId] = newPassport;
    }
    
    function retrieve(address _tokenId) public view returns (address, address[] memory, uint, uint[] memory, uint) {
        Passport memory passport = passports[_tokenId];
        return (passport.tokenId, passport.ownershipHistory, passport.productId, passport.historyTimestamps, passport.expiryDate);
    }
}
