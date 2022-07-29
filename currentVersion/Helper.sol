// SPDX-License-Identifier: jclopezpimentel
pragma solidity ^0.8.0;

//import "./Governable.sol";

abstract contract Helper{

  /**
   * @dev Error constants.
   */
  string private constant NOT_HELPER = "H0900";
  string internal constant HELPER_CANNOT_BE_OWNER = "H0901";
  string internal constant MILEAGE_MUST_BE_BIGGER = "H0902";
  string internal constant ALREADY_ASSIGNED_HELPER = "H0903";
  string internal constant NOT_TYPE_OF_HELPER = "H0904";
  string internal constant TYPE_OF_HELPER_COINCIDE = "H0905";
  string internal constant SERVICE_ALREADY_ASSIGNED = "H0906";
 
  address public helper = address(0);
  uint256 public LAST_SERVICE_MILEAGE=0;
  string  public LAST_SERVICE_DESCRIPTION="";
  uint256 public MILEAGE_RECORD=0;
  string  public MILEAGE_RECORD_DESCRIPTION="";
  string public genesisData;  //genesis information
  bool public insured = false;
  string public INSURANCE_DESCRIPTION;
  uint256 constant internal TYPE_SERVICE_HELPER=500;
 uint256 constant internal TYPE_INSURANCE_HELPER=501;

  event historicHelperUsers(
      address indexed helper,
      string about
  );

  event historicMileageRecord(
      address indexed emiter,
      uint256 mileage,
      string description
  );

  event historicServices(
      address indexed helper,
      uint256 mileage,
      string description
  );

  event historicInsuranceServices(
      address indexed helper,
      uint256 mileage,
      string description
  );


  /**
   * @dev The constructor sets the original `owner` of the contract to the sender account.
   */
//  constructor(){
    //legalOwner = msg.sender;
  //}

  /**
   * @dev Throws if called by any account other than the new owner.
   */
  modifier onlyHelper()
  {
    require(msg.sender == helper, NOT_HELPER);
    _;
  }


  /**
   * @notice When implemented this function must be included modifier canOperate
   * @dev Allows the owner to add who is the helper address.
   * @param _tokenId is an identifier for the token, it could be the NIV.
   * @param _helper address of the helper role.
   * @param _about is a description for what is assigned a helper.
   * @param _typeHelper is the vehicles' property or service that the helper can modify
   */
  function setHelper(uint256 _tokenId, address _helper, string memory _about, uint256 _typeHelper) external virtual;

 
  /**
    * @notice When implemented this function must be included modifier canOperate
    * @dev The legal owner must acept the service provided by the helper
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _accept pinpoints if the owner accept or reject the service data provided
  */
  function acceptHelperService(uint256 _tokenId, bool _accept) external virtual;


    

  function typeHelper(uint256 _typeHelper) internal pure returns (uint256){
    if(_typeHelper == TYPE_SERVICE_HELPER) return TYPE_SERVICE_HELPER;
    if(_typeHelper == TYPE_INSURANCE_HELPER) return TYPE_INSURANCE_HELPER;
    return 0; // _typeHelper was not found
  }

  /**
    * @notice When implemented this function must be included modifier onlyHelper
    * @dev This function sets a description on the service carried out 
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _mileage miles traveled when the services is carried out
    * @param _description it is a brief description of the service
  */
  function setMaintenanceService(uint256 _tokenId, uint256 _mileage, string memory _description) 
    external virtual;

  /**
    * @notice When implemented this function must be included modifier onlyHelper
    * @dev This function sets insurance details 
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _mileage miles traveled when the services is carried out
    * @param _description it is a brief description of the service
  */
  function setInsuranceDetails(uint256 _tokenId, uint256 _mileage, string memory _description) 
    external virtual;


 }