const { assert, expect } = require('chai')
const { ethers } = require('hardhat')

describe('avatarFacetTest', async function () {

    let equippableMethods

    before(async function () {
        const equippable = await ethers.getContractFactory('RMRKEquippableImpl')
        const initData = {
            erc20TokenAddress: "0x96fF4518A1e15b4C7bE7897408ad56e35f462A43",
            tokenUriIsEnumerable: true,
            royaltyRecipient: "0x96fF4518A1e15b4C7bE7897408ad56e35f462A43",
            royaltyPercentageBps: 2,
            maxSupply: 1000000,
            pricePerMint: 0
        };
        const equippableContract = await equippable.deploy("test", "test", "test", "test", initData)
        equippableMethods = await ethers.getContractAt('RMRKEquippableImpl', equippableContract.address)
    })

    it('uri should match', async () => {
        await equippableMethods.setTokenURI(1, "edfwef")
        assert.equal(await equippableMethods.tokenURI(1), "edfwef", 'uri should match')
    })

})