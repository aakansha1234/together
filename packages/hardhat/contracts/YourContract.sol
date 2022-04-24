pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable {

  address payable public other;
  uint256 public basis; // out of 10_000
  constructor() {}

  function setOther(address _other) external {
    other = payable(_other);
  }

  function setBasis(uint256 _basis) external {
    basis = _basis;
  }

  function distributeErc20(address erc20) external {
    uint256 bal = IERC20(erc20).balanceOf(address(this));
    IERC20(erc20).transferFrom(address(this), other, bal * basis / 10_000);
    IERC20(erc20).transferFrom(address(this), owner(), IERC20(erc20).balanceOf(address(this)));
  }

  function distributeEth() external {
    uint256 bal = address(this).balance;
    address(other).call{value: bal * basis / 10_000}("");
    owner().call{value: address(this).balance}("");
  }

  fallback() external payable {}
  receive() external payable {}
}
