pragma solidity ^0.5.9;

contract Vehicles{
    
    address government;
    address manufacturer;
    
    address payable seller;
    address payable buyer;
    
    
    struct FirstInfo{
        address manufacturer;
        string genesisInfo;
        string description;
        uint repuve;
    }

    struct OwnerData{
        address owner;
        string description;
    }

    struct Purchase{
        address nowner;
        uint value;
        string description;
    }
    
    FirstInfo[] firstI; 
    OwnerData[] owners;
    Purchase[] purchases;
    
    constructor() public{
        government = msg.sender;
    }
    

    function add(address m) public{
        require(msg.sender == government);
        manufacturer = m;
    }
    
    function registry(string memory newVehicle) public returns(uint) {
        require(manufacturer == msg.sender);
        require(firstI.length==0);
        string memory op = '{"operation":"registry", "typeoperation":"New Vehicle was added"}';
        uint n = firstI.length - 1;
        FirstInfo memory v = FirstInfo(msg.sender,newVehicle,op,n);
        OwnerData memory o = OwnerData(msg.sender,'{"operation":"newOwner", "typeoperation":"New Owner was added"}');
        owners.push(o);
        firstI.push(v);
        return v.repuve;
    }
    
    function getInfo(address vehicle) view public returns(string memory){
        require(address(this)==vehicle);
        uint index = firstI.length - 1;
        string memory regreso;
        if(index<0){
            regreso ='No se ha registrado ningún auto';
        }else{
            regreso = firstI[index].genesisInfo;
        }
        return regreso;
    }
    

    function buy(address thiscontract, uint amount) payable public {
        uint ro=owners.length-1;
        require(owners[ro].owner!=msg.sender); 
        require(address(this)==thiscontract); 
        require(address(msg.sender).balance>=amount);
        msg.value; // it is necessary to do a relation with the umount
        string memory op = '{"operation:"buy","date":"01/09/2019"}';
        Purchase memory p = Purchase(msg.sender,amount,op);
        purchases.push(p);
    
    }

}