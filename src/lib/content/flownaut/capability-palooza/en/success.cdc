import ExampleToken from "./contract.cdc"
import FungibleToken from "./utility/FungibleToken.cdc"
import FlowToken from "./utility/FlowToken.cdc" 

pub fun main(user: Address): Bool {
    let authAccount: AuthAccount = getAuthAccount(user)
    let publicAccount: PublicAccount = getAccount(user)

    authAccount.link<&FlowToken.Vault{FungibleToken.Balance}>(/public/capabilityPalooza, target: /storage/flowTokenVault)

    let cap = publicAccount.getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/capabilityPalooza)

    if cap.getType() != Type<Capability<&FlowToken.Vault{FungibleToken.Balance}>>() {
        return false
    }

    if let vault = publicAccount.getCapability<&ExampleToken.Vault{FungibleToken.Balance}>(/public/capabilityPalooza).borrow() {
        return vault.balance >= 100.0
    }

    return false
}