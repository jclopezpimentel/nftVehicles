pragma solidity ^0.8.13;
// SPDX-License-Identifier: jclopezpimentel

contract Vehicles{
    address owner;
    
    //address payable seller;
    //address payable buyer;
    
    
    struct Info{
        address owner;
        string role;
        string description;
        uint index;
    }

/*    struct Purchase{
        address nowner;
        uint value;
        string description;
    }
 */   
    Info[] listInfo; 
//    Purchase[] purchases;
    
    //The initiator of the contract must be a manufacturer
    constructor(){
        owner = msg.sender;
    }
        
    function registry(string memory newVehicle) public returns(uint) {
        require(owner == msg.sender);
        require(listInfo.length==0);
        uint n = listInfo.length;
        Info memory v = Info(msg.sender,'Manufacturer',newVehicle,n);
        listInfo.push(v);
        return v.index;
    }

    function char(bytes1 b) internal pure returns (bytes1) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function address2String(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(abi.encodePacked("0x",s));
    }
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function getErrors(uint n) private pure returns (string memory){
        string memory error1 = "{'Error':'Yes','number':'0', 'Code':'Vehicle has not been registered yet'}";
        string memory error2 = "{'Error':'Yes','number':'1', 'Code':'n is out of the array limits'}";
        string memory error100 = "{'Error':'Yes','number':'1000', 'Code':'unknown error'}";
        string memory resultado;
        if(n==0){
            resultado = error1;
        }else{
            if(n==1){
                resultado = error2;
            }else{
                resultado = error100;
            }
        }
        return resultado;
    }

    function getErrors2(uint n) public pure returns (string memory){
        string[] memory errors;
        errors[0] = "{'Error':'Yes','number':'0', 'Code':'Vehicle has not been registered yet'}";
        errors[1] = "{'Error':'Yes','number':'1', 'Code':'n is out of the array limits'}";
        errors[2] = "{'Error':'Yes','number':'1000', 'Code':'unknown error'}";
        string memory resultado;
        if(n<errors.length){
            resultado = errors[n];
        }else{
            resultado = errors[2];
        }
        return resultado; 
    }

    function getInfo(uint n) view private returns(string memory){
        uint index = listInfo.length;
        string memory regreso="";
        if(n>=index){
            regreso = getErrors(1);
        }else{
            index=n;
            string memory error = "'Error':'Not'";                
            string memory ow = string(abi.encodePacked("'owner':'", address2String(listInfo[index].owner),"'"));
            string memory rol = string(abi.encodePacked("'role':'", listInfo[index].role,"'"));
            string memory description = string(abi.encodePacked("'description':'", listInfo[index].description,"'"));                
            string memory indexs = string(abi.encodePacked("'index':'", uint2str(listInfo[index].index),"'"));
            regreso = string(abi.encodePacked("{", error, ",", ow, ",", rol, ",", description, ",", indexs, "}"));            
        }
        return regreso;
    }


     
    function getLastInfo(address vehicle) view public returns(string memory){
        require(address(this)==vehicle); //The token must be the correct one to obtain info
        string memory regreso;
        if(listInfo.length==0){
            regreso = getErrors(0);
        }else{
            regreso= getInfo(listInfo.length-1);
        }      
        return regreso;
    }

    function getNumberOfRegisters(address vehicle) view public returns(uint){
        require(address(this)==vehicle); //The token must be the correct one to obtain info
        return listInfo.length;
    }

    function getInfoN(address vehicle,uint n) view public returns(string memory){
        require(address(this)==vehicle); //The token must be the correct one to obtain info
        string memory regreso= getInfo(n);
        return regreso;
    }



/*    function buy(address thiscontract, uint amount) payable public {
        uint ro=owners.length-1;
        require(owners[ro].owner!=msg.sender); 
        require(address(this)==thiscontract); 
        require(address(msg.sender).balance>=amount);
        msg.value; // it is necessary to do a relation with the umount
        string memory op = '{"operation:"buy","date":"01/09/2019"}';
        Purchase memory p = Purchase(msg.sender,amount,op);
        purchases.push(p);
    
    }
*/
}