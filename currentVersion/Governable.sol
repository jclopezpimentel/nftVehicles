// SPDX-License-Identifier: jclopezpimentel
pragma solidity ^0.8.0;


import "./NFTokenMetadataMod.sol";

/**
 * @dev The government address provides basic authorization control and
 * simplifies the implementation of the owner permissions. 
 */
abstract contract Governable is NFTokenMetadataMod
{
  /**
   * @dev Private Error constants .
   */
  string private constant NOT_CURRENT_GOVERNMENT = "NOT EXECUTED BY GOVERNMENT"; 

  /**
   * @dev Internalt Error constants .
   */
  string internal constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "G0600";
  string internal constant NOT_CURRENT_LEGAL_OWNER = "G0601"; 
  string internal constant GOVERNMENT_ALREADY_ASSIGNED = "G0602";
  string internal constant GOVERNMENT_ERROR_ASSIGNED = "G0603";
  string internal constant IN_LEGAL_PROCESS = "G0604";
  string internal constant ERROR_TYPOF_TRANSACTION = "G0605";
  string internal constant STOLEN_FIRST_REPORTED = "G0606";
  string internal constant MANUFACTURER_REQUIRED = "G0607";
  string internal constant NEW_OWNER_MUST_BE_MANUFACTURER = "G0608";
  string internal constant ERROR_ISNOT_TYPOFTRANS = "G0609";
  string internal constant PAYING_GOVERNMENT_OWNERRIGHTS = "G0610";
  string internal constant PAYING_GOVERNMENT_STOLEN_STATUS = "G0611";
  string internal constant PAYING_GOVERNMENT_END_LIFE_CYCLE = "G0612";

  
  /**
   * @dev Transaction type constants.
   */
  uint internal constant CHANGE_OWNERRIGHTS = 100;
  uint internal constant CHANGE_STOLEN_STATUS = 101;
  uint internal constant INPURCHASE = 200;
  uint internal constant ENDLIFECYCLE = 300;
  

  /**
   * @dev Public attributes
   */
  address public legalOwner;
  address public possiblelegalOwner=address(0);  
  bool public active=false;
  address public manufacturer;
  /**
   * @dev stolen is a variable that the owner can modify to agile reporting this status.
   */
  bool public stolen = false;
  /**
   * @dev illegal states if the owner has illegal problems.
   */
  bool public legal = true;
  /**
   * @dev inlegalProcess states if the owner is currently processing a legal procedure 
   * if this is zero then it is not in legal process.
   */
  uint public inTransProcess = 0;




  /**
   * @dev Government address.
   */
  address public government;


  /**
   * @dev An event which is triggered when the owner is changed.
   * @param previousOwner The address of the previous owner.
   * @param newOwner The address of the new owner.
   */
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

    /**
   * @dev The constructor sets the original `owner` of the contract to the sender account.
   */
  /*constructor(){
    //owner = msg.sender;
  }
*/
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyLegalOwner()
  {
    require(msg.sender == legalOwner, NOT_CURRENT_LEGAL_OWNER);
    _;
  }

  /**
   * @dev Throws if called by any account other than the government.
   */
  modifier onlyGovernment()
  {
    require(msg.sender == government, NOT_CURRENT_GOVERNMENT);
    _;
  }

  /**
   * @dev Allows the manufacturer to add who is the government address.
   * @param _government The government address.
   */
  function setGovernment(address _government)  virtual internal;

  /**
   * @dev request to change the ownerright, only the new owner can modify this variable.
   */
  bool internal requestChangeOwnerright=false;




  /**
    * @notice When implemented must be included the modifier canOperate.
    * @dev The new owner requests to change the ownerright
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */

  function requestOwnerright(uint256 _tokenId) virtual external;


  /**
    * @notice When implemented must be included the modifier canOperate.
    * @dev The owner requests to change the stolen status
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */

  function requestChangeStolenStatus(uint256 _tokenId) virtual external;

/**
   * @dev transactionCost is the cost to execute the change of the owner rights.
   */
  uint256 public transactionGovCost=0;

  /**
   * @dev currentTransDebt is the current debt of the owner with the government.
   */
  uint256 public currentGovDebt = 0;



  /**
    * @notice The initial step to sell the token. When implemented must be included
    * the modifier onlyGovernment.
    * @dev The government establishes an initial price to sell the token
    * @param _transactionCost is the cost to execute the change of the owner rights
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */
  //function setCostToChangeOwnerright(uint256 _transactionCost, uint256 _tokenId) virtual external;


  /**
    * @notice When implemented must be included the modifier onlyGovernment.
    * @dev The government establishes an initial price to make the procedure
    * @param _transactionCost is the cost to execute the change of the owner rights
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _transactionType pinpoints for what type of transaction is the cost
  */
  function setCostForTheTransaction(uint256 _transactionCost, uint256 _tokenId, uint _transactionType) virtual external;

  /**
    * @notice This function must be called after function setCostToChangeOwnerright(...)
    * has been called.
    * @dev The new owner must pay to the government the established transaction cost
    * @param _government is the government address
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _transactionType pinpoints for what type of transaction is the cost
  */
  function payToTheGovernment(address payable _government, uint256 _tokenId, uint _transactionType) virtual external payable;

  
    /**
   * @dev Allows the owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
   
  function transferOwnerright(address _owner, address _newOwner,uint256 _tokenId) virtual internal;

  

  function typeTrans(uint _transactionType) internal pure returns (uint){
    if(_transactionType == CHANGE_OWNERRIGHTS) return CHANGE_OWNERRIGHTS;
    if(_transactionType == CHANGE_STOLEN_STATUS) return CHANGE_STOLEN_STATUS;
    if(_transactionType == INPURCHASE) return INPURCHASE;
    if(_transactionType == ENDLIFECYCLE) return ENDLIFECYCLE;
    return 0; // typeTrans was not found
  }

  function changeLegalStatus() internal {
     if(stolen==true){
       legal = false;
     }else{
       legal = true;
     }
  }


}