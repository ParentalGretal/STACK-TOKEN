import FungibleToken from 0x05
import stackToken from 0x05

transaction(receiverAccount: Address, amount: UFix64) {

    // Define references
    let signerVault: &stackToken.Vault
    let receiverVault: &stackToken.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&stackToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault not found in senderAccount")

        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&stackToken.Vault{FungibleToken.Receiver}>()
            ?? panic("Vault not found in receiverAccount")
    }

    execute {
        // Withdraw tokens from signer's vault and deposit into receiver's vault
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens transferred")
    }
}