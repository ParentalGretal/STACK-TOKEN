import FungibleToken from 0x05
import stackToken from 0x05

transaction() {

    // Define references
    let userVault: &stackToken.Vault{FungibleToken.Balance, FungibleToken.Provider,FungibleToken.Receiver ,stackToken.CollectionPublic }?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow vault capability and set account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&stackToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, stackToken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- stackToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&stackToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, stackToken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}