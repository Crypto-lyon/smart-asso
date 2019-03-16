pragma solidity >=0.4.22 <0.6.0;
import "./Mortal.sol";

contract Organization is Mortal {
    // A member of the organization
    struct Member {
        string firstName;
        string lastName;
        uint availableTokens;
        bool exists;
        uint id;
    }

    // A request made to add a new member to the organization
    struct accessRequest {
        string firstName;
        string lastName;
        bool exists;
        uint id;
        mapping(address => bool) hasVoted; // You wont fool us ><
        uint acceptedcount; // A counter to avoid a FUCKING BIG GAZ CONSUMING for loop to retrieve the %
    }

    // Organization informations
    string name;
    string id;
    string website;

    // All the members of the org
    mapping(address => Member) members;
    address[] membersAddresses;

    // All the membership requests
    mapping(address => accessRequest) accRequests;
    address[] accRequestsAddresses;

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
        membersAddresses.length = 0;
        // The owner is the first member
        members[msg.sender].firstName = "Jimmy";
        members[msg.sender].lastName = "Chambrade";
        members[msg.sender].exists = true;
        members[msg.sender].availableTokens = 100;
        members[msg.sender].id = membersAddresses.push(msg.sender);
    }

    // Returns organization informations
    function getOrganizationInfo() public view returns (string memory, string memory, string memory, uint) {
        return (name, id, website, getMembersCount());
    }

    // Request a membership for a given address, name, and surname
    function requestMembership (address _address, string memory _firstName, string memory _lastName) public {
        require(!accRequests[_address].exists, "A request has already been made for this address");
        require(!members[_address].exists, "This user is already a member of the organization");

        // Creation of a membership request for this "person"
        accRequests[_address].firstName = _firstName;
        accRequests[_address].lastName = _lastName;
        accRequests[_address].exists = true;
        accRequests[_address].acceptedcount = 0;
        accRequests[_address].id = accRequestsAddresses.push(_address);

        emit NewMembershipRequest(_address, _firstName, _lastName);
    }

    // Adds a member to the list given a membership request
    function addMember(accessRequest memory request, address _address) private returns (bool) {
        members[_address].firstName = request.firstName;
        members[_address].lastName = request.lastName;
        members[_address].exists = true;
        members[_address].availableTokens = 100;
        members[_address].id = membersAddresses.push(_address);
        
        return true;
    }

    // Vote from a member to accept or decline a membership request
    function acceptNewMembership(address _requester) public onlyMember {
        require(!accRequests[_requester].exists, "No request have been made for this address");
        require(!accRequests[_requester].hasVoted[msg.sender]); // You can't vote twice if you voted yes, otherwise you can switch (you know people do change..)
        
        accRequests[_requester].hasVoted[msg.sender] = true; // This address won't be able to vote anymore
        ++accRequests[_requester].acceptedcount; // __*Then*__ we increase the counter
        if (accRequests[_requester].acceptedcount > membersAddresses.length / 2) {
            // If a membership request reaches majority, it is accepted
            if (!addMember(accRequests[_requester], _requester)) {
                revert();
            }
            delete accRequests[_requester];
            emit VotedForNewMember(msg.sender, _requester, true);
        }
    }

    // Returns member informations
    function getMember(address _address) public view returns (address, string memory, string memory, uint, uint) {
        return (_address, members[_address].firstName, members[_address].lastName, members[_address].availableTokens, members[_address].id);
    }

    // Returns member list
    function getMemberList() public view returns (address[] memory) {
        return membersAddresses;
    }

    // Returns members count
    function getMembersCount() public view returns(uint) {
        return membersAddresses.length;
    }
}
