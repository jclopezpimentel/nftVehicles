// SPDX-License-Identifier: MIT
// this is a modified version of Ownable
pragma solidity ^0.8.0;

//import "./NFTokenMetadata2.sol";
import "./Governable.sol";

/**
 * @dev The contract has an owner address, and provides basic authorization control 
 * This contract is based on the source code at:
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
 */
abstract  contract Ownable is Governable
{

  /**
   * @dev Error constants.
   */


  string private constant NOT_CURRENT_NEW_OWNER = "NEW OWNER IS REQUIRED TO EXECUTE THE TRANSACTION";
  string private constant ERROR_NEW_OWNER_ASSIGNED = "ERROR: NEW OWNER ASSIGNED";

  /**
   * @dev Public attributes
   */
  
  uint256 public priceProposal=0;
  uint256 public currentDebt = 0;
  string public descriptionEndLife="";
  /**
   * @dev internal attributes.
   */

  address internal newOwner=address(0);
  address internal oldOwner=address(0);
  




  event historicOwnerrights(
      address indexed oldOwner,
      address indexed newOwner,
      uint256 transactionCost,
      uint256 _tokenId
  );

  event stolenLife(
      address owner,
      string description
  );

  /**
   * @dev The constructor sets the original `owner` of the contract to the sender account.
   */
  /*constructor(){
    //legalOwner = msg.sender;
  }
*/


  /**
   * @dev Throws if called by any account other than the new owner.
   */
  modifier onlyNewOwner()
  {
    require(msg.sender == newOwner, NOT_CURRENT_NEW_OWNER);
    _;
  }


  /**
   * @dev Allows the manufacturer to add who is the government address.
   * @param _government The government address.
   */
  function setGovernment(address _government) override internal{
    require(government == address(0), GOVERNMENT_ALREADY_ASSIGNED);
    government = _government;
    possiblelegalOwner = manufacturer;
    newOwner = manufacturer;
  }

 
  /**
    * @notice The initial step to sell the token
    * @dev The owner establishes an initial price to sell the token
    * @param _priceProposal is the proposed price in ethers of the token 
    * @param _possiblelegalOwner is the likely new owner
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */
  function setAgreedPrice(uint256 _priceProposal, address _possiblelegalOwner, uint256 _tokenId, uint _transactionType) 
    external canOperate(_tokenId) { // onlyLegalOwner
      require(legal==true,IN_LEGAL_PROCESS);
      require(_priceProposal>0,"PRICE PROPOSAL MUST BE BIGGER THAN 0");
      require(typeTrans(_transactionType)!=0,ERROR_TYPOF_TRANSACTION);
      inTransProcess = _transactionType;
      priceProposal = _priceProposal;
      currentDebt = priceProposal;
      possiblelegalOwner = _possiblelegalOwner;
      //givePermissionToTransferOwnership(possiblelegalOwner); //parece que esta función y la sig hacen lo mismo
      approve(possiblelegalOwner,_tokenId);
  }

/*   function getPriceProposal() external view returns (uint) {
      return priceProposal;
    }

   function getCurrentDebt() external view returns (uint) {
      return currentDebt;
    }

   function getpossibleNewOwner() external view returns (address) {
      return possibleNewOwner;
    }     
*/

 
  /**
    * @notice The new owner must pay for the purchase to the old owner
    * @dev payForThePurchase is a payable function where the new owner sends ethers
    * @param _owner is the current owner address
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */

function payForThePurchase(address payable _owner, uint256 _tokenId) virtual external payable;



    /**
   * @dev Allows the owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
   
  function transferOwnerright(address _owner, address _newOwner,uint256 _tokenId) override
    internal canOperate(_tokenId){
    require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
    require(_newOwner == possiblelegalOwner, ERROR_NEW_OWNER_ASSIGNED);
    if(_owner==address(0)){
      require(_newOwner == manufacturer,NEW_OWNER_MUST_BE_MANUFACTURER);
    }else{
      require(legalOwner == _owner,NOT_CURRENT_LEGAL_OWNER);
    }    
    emit OwnershipTransferred(_owner, _newOwner);
    legalOwner = _newOwner;
    newOwner=address(0);
    possiblelegalOwner = address(0);
  }


  /**
    * @notice When implemented this method must be included the onlyowner modifier
    * @dev reportAsStolen is a method that modifies the legal status of the vehicle and
    *   the stolen variable
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _description it is a brief description of the owner reporting the event
  */

function reportAsStolen(uint256 _tokenId, string memory _description) virtual external;

  /**
    * @notice When implemented this method must be included the onlyowner modifier
    * @dev reportEndLifeCycle is a very dangerous method, it requests to retirate the token
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _description it is a brief description of the owner reporting the event
  */

function reportEndLifeCycle(uint256 _tokenId, string memory _description) virtual external;


}