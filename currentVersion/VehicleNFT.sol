// SPDX-License-Identifier: jclopezpimentel
pragma solidity 0.8.0;
 
import "./Ownable.sol";
import "./Helper.sol";
 
contract VehicleNFT is Ownable, Helper{  
 
  //string internal roleOwner;  // manufacturer, moral or physical
  //string internal ownerName;  // Moral or physical name 
  //string genesisData;       //genesis information
  uint256 private tHelper=0;

  event historicTransactions(
      address indexed executor,
      //string roleExecutor,
      uint256 cost,
      //string ownerName,
      string data
  );


  string constant INCORRECT_USER = "V0800";
  string constant DESTINATION_COIN_ERROR = "V0801";
  string constant PAYING = "V0802";
  string constant TRANSFERING_OWNERSHIP = "V0803";
  string constant OWNER_HAS_ILLEGAL = "V0804";
  string constant ERROR_TOKEN_ID = "V0805";
  string constant INCORRECT_ID_TOKEN = "V0806";
  string constant INCORRECT_TYPE_TRANS = "V0807";
  string constant CANNOT_BE_EXECUTED = "V0808";
  string constant ALREADY_REQUESTED = "V0809";
  string constant ALREADY_REPORTED = "V0810";


  /**
    * @notice The initiator of the contract must be a manufacturer
    * @dev Creates a new NFT-vehicle with three parameters
    * @param _name is a generic name to distinguish the NFT-vehicle, e.g Mazda CX5 Sport Edition
    * @param _symbol is an identifier number of the vehicle, e.g. MazdaCX5SE2015
    * @param _data is the genesis information
  */
  constructor(string memory _name, string memory _symbol, string memory _data) {
    nftName = _name;
    nftSymbol = _symbol;
    manufacturer = msg.sender;
    genesisData = _data;
    emit historicTransactions(msg.sender,0,_data);
  }
 
  /**
    * @notice The manufacturer will be the first owner
    * @dev Establishes the first owner, the government and a token id 
    * @param _government is the government address
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */
  function mint(address _government, uint256 _tokenId) public{ 
    require(msg.sender==manufacturer,MANUFACTURER_REQUIRED);
    super._mint(manufacturer, _tokenId);
    setGovernment(_government);
  }


   function payForThePurchase(address payable _owner, uint256 _tokenId) override external payable{ // Checar si cualquiera podría pagar el token
     require(requestChangeOwnerright==false,CANNOT_BE_EXECUTED);
     require(msg.sender==possiblelegalOwner,INCORRECT_USER);
     //require(msg.value<=currentDebt,"PRICE PAYED IS MORE THAN PACTED");
     require(_owner==idToOwner[_tokenId],DESTINATION_COIN_ERROR);
     //tomar en cuenta el tipo de transaction
     require(inTransProcess==INPURCHASE,INCORRECT_TYPE_TRANS);
     _owner.transfer(msg.value);
     oldOwner = _owner;
     if(currentDebt - msg.value<=0){
       currentDebt = 0;
       emit historicTransactions(msg.sender,priceProposal,PAYING);
       //_transfer(msg.sender, _tokenId);
       //para utilizar _safeTransferFrom hay que hacer primero un approve() or setApprovalForAll()
       _safeTransferFrom(_owner, msg.sender, _tokenId, "");
       //address owner = ownerright();
       emit historicTransactions(legalOwner,0,TRANSFERING_OWNERSHIP);
       inTransProcess = 0;
       //owner = possibleNewOwner; //changing the owner
       //roleOwner = _roleNewOwner;  // changing role owner: manufacturer, moral or physical
     }else{
       currentDebt = currentDebt - msg.value;
     }
   }

  /**
    * @dev The new owner requests to change the ownerright
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */
  function requestOwnerright(uint256 _tokenId) override external canOperate(_tokenId) { //era onlyNewOwner 
      require(legal==true,OWNER_HAS_ILLEGAL);
      require(idToOwner[_tokenId]!=legalOwner,ERROR_TOKEN_ID);
      requestChangeOwnerright = true;
      inTransProcess = CHANGE_OWNERRIGHTS;
  }

  /**
    * @notice When implemented must be included the modifier canOperate.
    * @dev The owner requests to change the stolen status
    * @param _tokenId is an identifier for the token, it could be the NIV.
  */

  function requestChangeStolenStatus(uint256 _tokenId) override external canOperate(_tokenId) {
      require(inTransProcess!=CHANGE_STOLEN_STATUS,ALREADY_REQUESTED);
      require(stolen==true,STOLEN_FIRST_REPORTED);
      inTransProcess = CHANGE_STOLEN_STATUS;
  }


  function requirementTypeTransaction(uint _transactionType, uint256 _tokenId) private view {
      if(_transactionType == CHANGE_OWNERRIGHTS){
        require(idToOwner[_tokenId]!=legalOwner,ERROR_TOKEN_ID); // it is required to have a legal owner
        require(requestChangeOwnerright==true,OWNER_HAS_ILLEGAL);
      }else if(_transactionType == CHANGE_STOLEN_STATUS){
        require(stolen==true,STOLEN_FIRST_REPORTED);
      }else{
        require(stolen==false,"NOT IMPLEMENTED YET");
      }
  }

  /**
    * @notice When implemented must be included the modifier onlyGovernment.
    * Only a legaProcess can be carried out at once.
    * @dev The government establishes an initial price to make the procedure
    * @param _transactionCost is the cost to execute the legal procedure
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _transactionType pinpoints for what type of transcation is the cost
  */
  function setCostForTheTransaction(uint256 _transactionCost, uint256 _tokenId, uint _transactionType) override external onlyGovernment {
      require(typeTrans(_transactionType)!=0,ERROR_TYPOF_TRANSACTION);
      require(inTransProcess>0,IN_LEGAL_PROCESS);      
      require(inTransProcess==_transactionType,INCORRECT_TYPE_TRANS);
      requirementTypeTransaction(_transactionType,_tokenId);
      transactionGovCost = _transactionCost;
      currentGovDebt = _transactionCost;
  }

/*
  function closingOwnerright(uint256 _tokenId) private {
       emit historicOwnerrights(oldOwner,possiblelegalOwner,transactionGovCost,_tokenId);
       emit historicTransactions(msg.sender,transactionGovCost,PAYING_GOVERNMENT_OWNERRIGHTS);
       transferOwnerright(oldOwner, possiblelegalOwner,_tokenId);
       requestChangeOwnerright = false;
       active = true;
  }
*/
/*
    function closingStolenChangeStatus() private {
       emit historicTransactions(msg.sender,transactionGovCost,PAYING_GOVERNMENT_STOLEN_STATUS);
       stolen = false;
       changeLegalStatus();
    }
*/

  function completeTransaction(uint256 _tokenId, uint _transactionType) private{
      if(_transactionType == CHANGE_OWNERRIGHTS){
        //closingOwnerright(_tokenId);
        emit historicOwnerrights(oldOwner,possiblelegalOwner,transactionGovCost,_tokenId);
        emit historicTransactions(msg.sender,transactionGovCost,PAYING_GOVERNMENT_OWNERRIGHTS);
        transferOwnerright(oldOwner, possiblelegalOwner,_tokenId);
        requestChangeOwnerright = false;
        active = true;
      }else if(_transactionType == CHANGE_STOLEN_STATUS){
        //closingStolenChangeStatus();
        emit historicTransactions(msg.sender,transactionGovCost,PAYING_GOVERNMENT_STOLEN_STATUS);
        stolen = false;
        changeLegalStatus();
      }else if(_transactionType == ENDLIFECYCLE){
        emit historicTransactions(msg.sender,transactionGovCost,PAYING_GOVERNMENT_END_LIFE_CYCLE);
        active = false;
        _removeNFToken(legalOwner,_tokenId);
      }else{
        //
      }
  }

  /**
    * @notice This function must be called after function setCostForTheTransaction
    * has been called.
    * @dev It must be payed to the government the established transaction cost
    * @param _government is the government address
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _transactionType pinpoints for what type of transcation is the cost
  */
   function payToTheGovernment(address payable _government, uint256 _tokenId, uint _transactionType) override external payable{ // 
      require(typeTrans(_transactionType)!=0,ERROR_TYPOF_TRANSACTION);
      //require(msg.sender==possibleNewOwner,INCORRECT_USER);
      require(_government==government,GOVERNMENT_ERROR_ASSIGNED);
      //require(owner==idToOwner[_tokenId],INCORRECT_ID_TOKEN); //checar si aplica en ownerrights quizá es newowner
      //tomar en cuenta el tipo de transaction
      require(inTransProcess==_transactionType,INCORRECT_TYPE_TRANS);
      _government.transfer(msg.value);
      if(currentGovDebt - msg.value<=0){
        currentGovDebt = 0;
        completeTransaction(_tokenId,_transactionType);
        inTransProcess = 0;
      }else{
        currentGovDebt = currentGovDebt - msg.value;
      }
   }

  /**
    * @dev reportAsStolen is a method that modifies the legal status of the vehicle and
    *   the stolen variable
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _description it is a brief description of the owner reporting the event
  */

function reportAsStolen(uint256 _tokenId, string memory _description) override external 
  canOperate(_tokenId){
    require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
    require(stolen==false,ALREADY_REPORTED);
    require(inTransProcess==0,IN_LEGAL_PROCESS);
    stolen = true;
    legal = false;
    emit stolenLife(msg.sender,_description);
  }

  bool private requestActive=false;
  /**
    * @notice When implemented this method must be included the onlyowner modifier
    * @dev reportEndLifeCycle is a very dangerous method, it requests to retirate the token
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _description it is a brief description of the owner reporting the event
  */
function reportEndLifeCycle(uint256 _tokenId, string memory _description) override external 
  canOperate(_tokenId){
    require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
    require(requestActive==false,ALREADY_REPORTED);
    require(inTransProcess==0,IN_LEGAL_PROCESS);
    requestActive = true;
    legal = false;
    inTransProcess = ENDLIFECYCLE;
    descriptionEndLife = _description;
  }


 /**
   * @notice When implemented this function must be included modifier canOperate
   * @dev Allows the owner to add who is the helper address.
   * @param _tokenId is an identifier for the token, it could be the NIV.
   * @param _helper address of the helper role.
   * @param _about is a description for what is assigned a helper.
   * @param _typeHelper is the vehicles' property or service that the helper can modify
   */
  function setHelper(uint256 _tokenId, address _helper, string memory _about, uint256 _typeHelper) override external
   canOperate(_tokenId){
    require(helper==address(0),ALREADY_ASSIGNED_HELPER);
    require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
    require(_helper!=legalOwner,HELPER_CANNOT_BE_OWNER);
    require(typeHelper(_typeHelper)>0,NOT_TYPE_OF_HELPER);
    require(inTransProcess==0,IN_LEGAL_PROCESS);
    tHelper = _typeHelper;
    helper = _helper;
    inTransProcess = _typeHelper;
    emit historicHelperUsers(_helper, _about);
  }


  /**
    * @notice When implemented this function must be included modifier canOperate
    * @dev The legal owner must acept the service provided by the helper
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _accept pinpoints if the owner accept or reject the service data provided
  */
  function acceptHelperService(uint256 _tokenId, bool _accept) override external canOperate(_tokenId){
    require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
    require(helper!=address(0),NOT_TYPE_OF_HELPER);
    TEMP_MILEAGE= 0;
    if(_accept==true){
        helper = address(0);
        TEMP_DESCRIPTION="";
        inTransProcess = 0;
        emit historicMileageRecord(helper,MILEAGE_RECORD,MILEAGE_RECORD_DESCRIPTION);
        if(tHelper==TYPE_SERVICE_HELPER) emit historicServices(helper,LAST_SERVICE_MILEAGE,LAST_SERVICE_DESCRIPTION);
        if(tHelper==TYPE_INSURANCE_HELPER){ emit historicInsuranceServices(helper,MILEAGE_RECORD,LAST_SERVICE_DESCRIPTION);
          insured = true;
        }
      }else{
        MILEAGE_RECORD_DESCRIPTION = TEMP_DESCRIPTION_RECORD;
        MILEAGE_RECORD = TEMP_MILEAGE;
        if(tHelper==TYPE_SERVICE_HELPER){
          LAST_SERVICE_MILEAGE = TEMP_MILEAGE;
          LAST_SERVICE_DESCRIPTION = TEMP_DESCRIPTION;
        }
        if(tHelper==TYPE_INSURANCE_HELPER){
          INSURANCE_DESCRIPTION = TEMP_DESCRIPTION;
        }
      }
  }


  uint256 private TEMP_MILEAGE=0;
  string private  TEMP_DESCRIPTION;
  uint256 private TEMP_MILEAGE_RECORD;
  string private  TEMP_DESCRIPTION_RECORD;
 
  /**
    * @notice When implemented this function must be included modifier onlyHelper
    * @dev This function sets a description on the service carried out 
    * @param _tokenId is an identifier for the token, it could be the NIV.    
    * @param _mileage miles traveled when the services is carried out
    * @param _description it is a brief description of the service.
  */
  function setMaintenanceService(uint256 _tokenId, uint256 _mileage, string memory _description) 
    override external onlyHelper{
      require(TEMP_MILEAGE==0,SERVICE_ALREADY_ASSIGNED);
      require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
      require((_mileage>LAST_SERVICE_MILEAGE) && (_mileage>=MILEAGE_RECORD),MILEAGE_MUST_BE_BIGGER);
      require(tHelper==TYPE_SERVICE_HELPER,TYPE_OF_HELPER_COINCIDE);
      TEMP_MILEAGE= LAST_SERVICE_MILEAGE;
      TEMP_DESCRIPTION=LAST_SERVICE_DESCRIPTION;
      LAST_SERVICE_MILEAGE = _mileage;
      LAST_SERVICE_DESCRIPTION = _description;
      TEMP_MILEAGE_RECORD = MILEAGE_RECORD;
      TEMP_DESCRIPTION_RECORD = MILEAGE_RECORD_DESCRIPTION;
      MILEAGE_RECORD = _mileage;
      MILEAGE_RECORD_DESCRIPTION = _description;
    }


  /**
    * @notice When implemented this function must be included modifier onlyHelper
    * @dev This function sets insurance details 
    * @param _tokenId is an identifier for the token, it could be the NIV.
    * @param _mileage miles traveled when the services is carried out    
    * @param _description it is a brief description of the service
  */
  function setInsuranceDetails(uint256 _tokenId, uint256 _mileage, string memory _description) 
    override external onlyHelper{
      require(TEMP_MILEAGE==0,SERVICE_ALREADY_ASSIGNED);
      require(idToOwner[_tokenId]==legalOwner,ERROR_TOKEN_ID);
      require(tHelper==TYPE_INSURANCE_HELPER,TYPE_OF_HELPER_COINCIDE);
      TEMP_MILEAGE=1;
      TEMP_DESCRIPTION=INSURANCE_DESCRIPTION;
      INSURANCE_DESCRIPTION = _description;
      MILEAGE_RECORD = _mileage;
      MILEAGE_RECORD_DESCRIPTION = _description;
     }
}