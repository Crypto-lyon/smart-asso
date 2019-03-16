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
        uint acceptedcount;
        uint rejectedcount;
    }

    string name;
    string id;
    string website;

    mapping(address => Member) members;
    address[] membersAddress;

    mapping(address => Request) requests;
    address[] requestsAddress;

    event NewMembershipRequest(address requester, string firstName, string lastName);
    event VotedForNewMember(address member, address requester, bool decision);

    modifier onlyMember {
        require(members[msg.sender].exists, "Address is not a member");
        _;
    }

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

    function requestMembership (address _address, string memory _firstName, string memory _lastName) public  returns (string memory) {
        if(requests[_address].exists == true) {
            revert("User already made request with this address.");
        }

        if(members[_address].exists == true) {
            revert("User is already a member of organization");
        }

        requests[_address].firstName = _firstName;
        requests[_address].lastName = _lastName;
        requests[_address].exists = true;
        requests[_address].acceptedcount = 0;
        requests[_address].rejectedcount = 0;
        requests[_address].exists = true;
        requests[_address].id = requestsAddress.push(_address);

        emit NewMembershipRequest(_address, _firstName, _lastName);
        return requests[_address].firstName;
    }

    // Add a new member
    function addMember(address _address, string memory _firstName, string memory _lastName) public onlyMember returns (string memory) {
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

    function acceptNewMembership(address _requester, bool _decision) public onlyMember returns (bool) {
        if(requests[_requester].exists != true) {
            revert("Unknown address in requester list");
        }
        
        if(_decision == true){
            requests[_requester].acceptedcount ++;
        } else {
            requests[_requester].rejectedcount ++;
        }

        emit VotedForNewMember(msg.sender, _requester, _decision);

        // todo check if quorum is reached and add or remove membership

        return _decision;
    }

    // Returns member informations
    function getMember(address _address) public view returns (address, string memory, string memory, uint, uint) {
        return (_address, members[_address].firstName, members[_address].lastName, members[_address].availableTokens, members[_address].id);
    }

    // Returns member list
    function getMemberList() public view returns (address[] memory) {
        return membersAddress;
    }

    // Returns members count
    function getMembersCount() public view returns(uint) {
        return membersAddress.length;
    }
}
