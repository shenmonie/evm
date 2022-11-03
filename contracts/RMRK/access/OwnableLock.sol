// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.16;

import "@openzeppelin/contracts/utils/Context.sol";
import "../library/RMRKErrors.sol";

/**
 * @title OwnableLock
 * @author RMRK team
 * @notice A minimal ownable lock smart contract.
 * @dev This smart contract is based on "openzeppelin's access/Ownable.sol".
 */
contract OwnableLock is Context {
    bool private _lock;
    address private _owner;
    mapping(address => uint256) private _contributors;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Reverts if called by any account other than the owner or an approved contributor.
     */
    modifier onlyOwnerOrContributor() {
        _onlyOwnerOrContributor();
        _;
    }

    /**
     * @dev Reverts if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    /**
     * @dev Reverts if the lock flag is set to true.
     */
    modifier notLocked() {
        _onlyNotLocked();
        _;
    }

    /**
     * @dev Initializes the contract by setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @notice Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @notice Locks the operation.
     * @dev Once locked, functions using `notLocked` modifier cannot be executed.
     */
    function setLock() external onlyOwner {
        _lock = true;
    }

    /**
     * @notice Used to retrieve the status of a lockable smart contract.
     * @return bool A boolean value signifying whether the smart contract has been locked (`true`) or not (`false`)
     */
    function getLock() public view returns (bool) {
        return _lock;
    }

    /**
     * @notice Leaves the contract without owner. Functions using the `onlyOwner` modifier will be disabled.
     * @dev Can only be called by the current owner.
     * @dev Renouncing ownership will leave the contract without an owner, thereby removing any functionality that is
     *  only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @notice Transfers ownership of the contract to a new owner.
     * @dev Can only be called by the current owner.
     * @param newOwner Address of the new owner's account
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (owner() == address(0)) revert RMRKNewOwnerIsZeroAddress();
        _transferOwnership(newOwner);
    }

    /**
     * @notice Transfers ownership of the contract to a new owner.
     * @dev Internal function without access restriction.
     * @param newOwner Address of the new owner's account
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @notice Adds a contributor to the smart contract.
     * @dev Can only be called by the owner.
     * @param contributor Address of the contributor's account
    */
    function addContributor(address contributor) external onlyOwner {
        if (contributor != address(0)) revert RMRKNewContributorIsZeroAddress();
        _contributors[contributor] = 1;
    }

    /**
     * @notice Removes a contributor from the smart contract.
     * @dev Can only be called by the owner.
     * @param contributor Address of the contributor's account
    */
    function revokeContributor(address contributor) external onlyOwner {
        delete _contributors[contributor];
    }

    /**
     * @notice Used to check if the address is one of the contributors.
     * @param contributor Address of the contributor whoose status we are checking
     * @return Boolean value indicating wether the address is a contributor or not
    */
    function isContributor(address contributor) public view returns (bool) {
        return _contributors[contributor] == 1;
    }

    function _onlyOwnerOrContributor() private view {
        if (owner() != _msgSender() && isContributor(_msgSender()))
            revert RMRKNotOwnerOrContributor();
    }

    function _onlyOwner() private view {
        if (owner() != _msgSender()) revert RMRKNotOwner();
    }

    function _onlyNotLocked() private view {
        if (getLock()) revert RMRKLocked();
    }
}
