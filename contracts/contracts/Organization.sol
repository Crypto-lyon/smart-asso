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
    struct AccessRequest {
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
    mapping(address => Member) public members;
    address[] public membersAddresses;

    // All the membership requests
    mapping(address => AccessRequest) public accessRequests;
    address[] public accessRequestsAddresses;

    event NewMembershipRequest(address requester, string firstName, string lastName);
    event VotedForNewMember(address indexed voter, address requester, bool decision);
    event NewMemberAccepted(address requester, string firstName, string lastName);

    modifier onlyMember {
        require(members[msg.sender].exists, "Address is not a member");
        _;
    }

    // Init organization
    constructor(
        string memory _name,
        string memory _id,
        string memory _website) public 
    {
        name = _name;
        id = _id;
        website = _website;
        membersAddresses.length = 0;
        
        // The owner is the first member
        AccessRequest memory admin = AccessRequest({
            firstName: "admin",
            lastName: "admin",
            exists: true,
            id: 0,
            acceptedcount: 0
        });
        _addMember(admin, msg.sender);
    }

    // Returns organization informations
    function getOrganizationInfo() public view returns (
        string memory orgName,
        string memory orgId,
        string memory orgWebsite,
        uint orgMembersCount)
    {
        return (name, id, website, getMembersCount());
    }

    // Request a membership for a given address, name, and surname
    function requestMembership (string memory _firstName, string memory _lastName) public {
        require(!accessRequests[msg.sender].exists, "A request has already been made for this address");
        require(!members[msg.sender].exists, "This user is already a member of the organization");

        // Creation of a membership request for this "person"
        accessRequests[msg.sender].firstName = _firstName;
        accessRequests[msg.sender].lastName = _lastName;
        accessRequests[msg.sender].exists = true;
        accessRequests[msg.sender].acceptedcount = 0;
        accessRequests[msg.sender].id = accessRequestsAddresses.push(msg.sender);

        emit NewMembershipRequest(msg.sender, _firstName, _lastName);
    }

    // Adds a member to the list given a membership request
    function _addMember(AccessRequest memory request, address _address) private returns (bool) {
        members[_address].firstName = request.firstName;
        members[_address].lastName = request.lastName;
        members[_address].exists = request.exists;
        members[_address].availableTokens = 100;
        members[_address].id = membersAddresses.push(_address);
        
        emit NewMemberAccepted(_address, members[_address].firstName, members[_address].lastName);

        return true;
    }

    // Vote from a member to accept or decline a membership request
    function acceptNewMembership(address _requester) public onlyMember {
        require(accessRequests[_requester].exists, "No request have been made for this address");
        // You can't vote twice if you voted yes, otherwise you can switch (you know people do change..)
        require(!accessRequests[_requester].hasVoted[msg.sender], "You can't vote twice");
        
        accessRequests[_requester].hasVoted[msg.sender] = true; // This address won't be able to vote anymore
        ++accessRequests[_requester].acceptedcount; // __*Then*__ we increase the counter

        emit VotedForNewMember(msg.sender, _requester, true);

        if (accessRequests[_requester].acceptedcount > membersAddresses.length / 2) {
            // If a membership request reaches majority, it is accepted
            if (!_addMember(accessRequests[_requester], _requester)) {
                revert("error while inserting new member");
            }
            delete accessRequests[_requester];
        }
    }

    // Returns members count
    function getMembersCount() public view returns(uint) {
        return membersAddresses.length;
    }
}
