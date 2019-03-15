pragma solidity >=0.4.22 <0.6.0;
import "./Mortal.sol";

contract Organization is Mortal {

    struct Member {
        string firstName;
        string lastName;
        uint availableTokens;
        bool exists;
        uint id;
    }

    struct Request {
        string firstName;
        string lastName;
        bool exists;
        uint id;
    }

    string name;
    string id;
    string website;

    mapping(address => Member) members;
    address[] membersAddress;

    mapping(address => Member) requests;
    address[] requestsAddress;

    // Init organization
    constructor(string memory _name, string memory _id, string memory _website) public {
        name = _name;
        id = _id;
        website = _website;
        membersAddress.length = 0;
    }

    // Returns organization informations
    function getOrganizationInfo() public view returns (string memory, string memory, string memory, uint) {
        return (name, id, website, getMembersCount());
    }

    function requestMembership(address _address, string memory _firstName, string memory _lastName) public  returns (string memory) {

        if(requests[_address].exists == true) {
            revert("User already made request with this address.");
        }

        requests[_address].firstName = _firstName;
        requests[_address].lastName = _lastName;
        requests[_address].exists = true;
        requests[_address].id = requestsAddress.push(_address);

        return requests[_address].firstName;
    }

    // Add a new member
    function addMember(address _address, string memory _firstName, string memory _lastName) public  returns (string memory) {
        require(msg.sender == owner, "User must be owner to add Member");

        if(members[_address].exists == true) {
            revert("User already exists.");
        }

        members[_address].firstName = _firstName;
        members[_address].lastName = _lastName;
        members[_address].exists = true;
        members[_address].availableTokens = 100;
        members[_address].id = membersAddress.push(_address);

        return members[_address].firstName;
    }

    // Only organization members or owners can view others members
    function isAddressAlowed(address _address) public view returns (bool) {
        if(members[_address].exists == true || _address == owner) {
            return true;
        } else {
            return false;
        }
    }

    // Returns member informations
    function getMember(address _address) public view returns (address, string memory, string memory, uint, uint) {
        require(isAddressAlowed(msg.sender), "Address not allowed");
        require(members[_address].exists == true, "User not found.");

        return (_address, members[_address].firstName, members[_address].lastName, members[_address].availableTokens, members[_address].id);
    }

    // Return member list
    function getMemberList() public view returns (address[] memory) {
        require(isAddressAlowed(msg.sender), "Address not allowed");
        return membersAddress;
    }

    // Returns members count
    function getMembersCount() public view returns(uint) {
        return membersAddress.length;
    }


}
