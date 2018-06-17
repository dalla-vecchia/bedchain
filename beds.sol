pragma solidity ^0.4.18;

// storing strings is very expensive so this presently has mostly bytes32 as a storage.
// we need to use a data store such as IPFS in conjunction with the contract.

contract Beds {

    struct CareHome {
        uint NumberFreeBeds;
        uint NumberUsedBeds;
    }

    struct PatientBed {
        bytes32 CareHomeID;
        uint WardNumber;
        uint BuildingNumber;
    }

    mapping (bytes32 => PatientBed) public PatientBeds; // patient maps to a bed
    mapping (bytes32 => CareHome) public CareHomes; // carehomeid mapped to carehome details
    bytes32[] public Patients; // patients - hash of details - store details on ipfs

// hash of patient, stored on IPFS
function addPatient(bytes32 PatientID) public {
  Patients.push(PatientID);
}

function readPatientBeds (bytes32 patientid) view  public returns (bytes32, uint, uint) {
    return (PatientBeds[patientid].CareHomeID,
    PatientBeds[patientid].WardNumber,
    PatientBeds[patientid].BuildingNumber);
}

function addPatientBed (bytes32 PatientID, bytes32 _CareHomeID, uint _WardNumber, uint _BuildingNumber) public {
    PatientBeds[PatientID].CareHomeID=_CareHomeID;
    PatientBeds[PatientID].WardNumber=_WardNumber;
    PatientBeds[PatientID].BuildingNumber=_BuildingNumber;
    uint _NumberFreeBeds=CareHomes[_CareHomeID].NumberFreeBeds;
    uint _NumberUsedBeds=CareHomes[_CareHomeID].NumberUsedBeds;
    CareHomes[_CareHomeID].NumberFreeBeds=_NumberFreeBeds--; // full app needs error handling
    CareHomes[_CareHomeID].NumberUsedBeds=_NumberUsedBeds++;

}

function addCareHome (bytes32 CareHomeID, uint _NumberFreeBeds, uint _NumberUsedBeds) public {
    CareHomes[CareHomeID].NumberFreeBeds=_NumberFreeBeds;
    CareHomes[CareHomeID].NumberUsedBeds=_NumberUsedBeds;
}


    function () payable public {
    }

}
