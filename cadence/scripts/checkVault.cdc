import FungibleToken from 0x05
import stackToken from 0x05

pub fun main(account: Address) {

    // Borrow the public vault capability and handle errors
    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&stackToken.Vault{FungibleToken.Balance}>()
        ?? panic("Vault not found, setup might be incomplete")

    log("Vault setup verified successfully")
}