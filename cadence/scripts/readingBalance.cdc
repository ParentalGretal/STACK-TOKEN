import FungibleToken from 0x05
import stackToken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &stackToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, stackToken.CollectionPublic }? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&stackToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, stackToken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- stackToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&stackToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, stackToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &stackToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&stackToken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &stackToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, stackToken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&stackToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, stackToken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if stackToken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a stackToken vault")
        } else {
            log("This is not a stackToken vault")
        }
    }
}