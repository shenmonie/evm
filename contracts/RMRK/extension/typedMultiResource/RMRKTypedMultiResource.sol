// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.15;

import "../../multiresource/RMRKMultiResource.sol";
import "./RMRKTypedMultiResourceAbstract.sol";

abstract contract RMRKTypedMultiResource is
    RMRKTypedMultiResourceAbstract,
    RMRKMultiResource
{
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, RMRKMultiResource)
        returns (bool)
    {
        return
            RMRKMultiResource.supportsInterface(interfaceId) ||
            interfaceId == type(IRMRKTypedMultiResource).interfaceId;
    }
}
