// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public immutable owner;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    enum Stage {
        Init,
        RawMaterialSupply,
        Manufacture,
        Distribution,
        Retail,
        Sold
    }
    uint256 public medicineCtr;
    uint256 public rmsCtr;
    uint256 public manCtr;
    uint256 public disCtr;
    uint256 public retCtr;

    struct Medicine {
        uint256 id;
        string name;
        string description;
        uint256 RMSid;
        uint256 MANid;
        uint256 DISid;
        uint256 RETid;
        Stage stage;
    }

    mapping(uint256 => Medicine) public medicineStock;

    struct Participant {
        address addr;
        uint256 id;
        string name;
        string place;
    }

    mapping(uint256 => Participant) public rawMaterialSuppliers;
    mapping(uint256 => Participant) public manufacturers;
    mapping(uint256 => Participant) public distributors;
    mapping(uint256 => Participant) public retailers;

    event ParticipantAdded(string role, uint256 id, string name);
    event MedicineAdded(uint256 id, string name);
    event MedicineStageUpdated(uint256 id, Stage stage);

    function showStage(uint256 _medicineID) public view returns (string memory) {
        require(medicineCtr > 0, "No medicines in stock");
        require(_medicineID > 0 && _medicineID <= medicineCtr, "Invalid medicine ID");

        Stage stage = medicineStock[_medicineID].stage;

        if (stage == Stage.Init) return "Medicine Ordered";
        if (stage == Stage.RawMaterialSupply) return "Raw Material Supply Stage";
        if (stage == Stage.Manufacture) return "Manufacturing Stage";
        if (stage == Stage.Distribution) return "Distribution Stage";
        if (stage == Stage.Retail) return "Retail Stage";
        if (stage == Stage.Sold) return "Medicine Sold";

        revert("Invalid stage");
    }

    function addParticipant(
        string memory role,
        address _address,
        string memory _name,
        string memory _place
    ) private {
        uint256 id;
        Participant memory newParticipant = Participant(_address, 0, _name, _place);

        if (keccak256(bytes(role)) == keccak256(bytes("RMS"))) {
            id = ++rmsCtr;
            newParticipant.id = id;
            rawMaterialSuppliers[id] = newParticipant;
        } else if (keccak256(bytes(role)) == keccak256(bytes("MAN"))) {
            id = ++manCtr;
            newParticipant.id = id;
            manufacturers[id] = newParticipant;
        } else if (keccak256(bytes(role)) == keccak256(bytes("DIS"))) {
            id = ++disCtr;
            newParticipant.id = id;
            distributors[id] = newParticipant;
        } else if (keccak256(bytes(role)) == keccak256(bytes("RET"))) {
            id = ++retCtr;
            newParticipant.id = id;
            retailers[id] = newParticipant;
        } else {
            revert("Invalid role");
        }

        emit ParticipantAdded(role, id, _name);
    }

    function addRMS(address _address, string memory _name, string memory _place) public onlyOwner {
        addParticipant("RMS", _address, _name, _place);
    }

    function addManufacturer(address _address, string memory _name, string memory _place) public onlyOwner {
        addParticipant("MAN", _address, _name, _place);
    }

    function addDistributor(address _address, string memory _name, string memory _place) public onlyOwner {
        addParticipant("DIS", _address, _name, _place);
    }

    function addRetailer(address _address, string memory _name, string memory _place) public onlyOwner {
        addParticipant("RET", _address, _name, _place);
    }

    function updateMedicineStage(uint256 _medicineID, Stage _newStage, string memory role) private {
        require(_medicineID > 0 && _medicineID <= medicineCtr, "Invalid medicine ID");
        require(uint8(_newStage) > uint8(medicineStock[_medicineID].stage), "Invalid stage transition");

        uint256 participantId = findParticipant(msg.sender, role);
        require(participantId > 0, "Participant not found");

        if (_newStage == Stage.RawMaterialSupply) {
            medicineStock[_medicineID].RMSid = participantId;
        } else if (_newStage == Stage.Manufacture) {
            medicineStock[_medicineID].MANid = participantId;
        } else if (_newStage == Stage.Distribution) {
            medicineStock[_medicineID].DISid = participantId;
        } else if (_newStage == Stage.Retail) {
            medicineStock[_medicineID].RETid = participantId;
        }

        medicineStock[_medicineID].stage = _newStage;
        emit MedicineStageUpdated(_medicineID, _newStage);
    }

    function RMSsupply(uint256 _medicineID) public {
        updateMedicineStage(_medicineID, Stage.RawMaterialSupply, "RMS");
    }

    function Manufacturing(uint256 _medicineID) public {
        updateMedicineStage(_medicineID, Stage.Manufacture, "MAN");
    }

    function Distribute(uint256 _medicineID) public {
        updateMedicineStage(_medicineID, Stage.Distribution, "DIS");
    }

    function Retail(uint256 _medicineID) public {
        updateMedicineStage(_medicineID, Stage.Retail, "RET");
    }

    function sold(uint256 _medicineID) public {
        require(_medicineID > 0 && _medicineID <= medicineCtr, "Invalid medicine ID");
        uint256 _id = findParticipant(msg.sender, "RET");
        require(_id > 0, "Retailer not found");
        require(_id == medicineStock[_medicineID].RETid, "Only the correct retailer can mark medicine as sold");
        require(medicineStock[_medicineID].stage == Stage.Retail, "Medicine is not in Retail stage");

        medicineStock[_medicineID].stage = Stage.Sold;
        emit MedicineStageUpdated(_medicineID, Stage.Sold);
    }

    function addMedicine(string memory _name, string memory _description) public onlyOwner {
        require(rmsCtr > 0 && manCtr > 0 && disCtr > 0 && retCtr > 0, "All participants must be added before adding medicine");
        medicineCtr++;
        medicineStock[medicineCtr] = Medicine(
            medicineCtr,
            _name,
            _description,
            0,
            0,
            0,
            0,
            Stage.Init
        );
        emit MedicineAdded(medicineCtr, _name);
    }

    function findParticipant(address _address, string memory role) private view returns (uint256) {
        uint256 counter;
        if (keccak256(bytes(role)) == keccak256(bytes("RMS"))) {
            counter = rmsCtr;
            for (uint256 i = 1; i <= counter; i++) {
                if (rawMaterialSuppliers[i].addr == _address) return rawMaterialSuppliers[i].id;
            }
        } else if (keccak256(bytes(role)) == keccak256(bytes("MAN"))) {
            counter = manCtr;
            for (uint256 i = 1; i <= counter; i++) {
                if (manufacturers[i].addr == _address) return manufacturers[i].id;
            }
        } else if (keccak256(bytes(role)) == keccak256(bytes("DIS"))) {
            counter = disCtr;
            for (uint256 i = 1; i <= counter; i++) {
                if (distributors[i].addr == _address) return distributors[i].id;
            }
        } else if (keccak256(bytes(role)) == keccak256(bytes("RET"))) {
            counter = retCtr;
            for (uint256 i = 1; i <= counter; i++) {
                if (retailers[i].addr == _address) return retailers[i].id;
            }
        } else {
            revert("Invalid role");
        }
        return 0;
    }
}