# Encryption

First of all you will need to have the key(128 or 256) and IV 

```swift
let key128   = "8745231065432717"
let key256   = "82564903257897543401126783548762"
let iv       = "CODIUMCOMPANYLtd"
```
for encryption(128 or 256) you can use the method below 

```swift
let encryptedPassword128 = aes128?.encrypt(string: password)
let encryptedPassword256 = aes256?.encrypt(string: password)
```
for the decryption(128 or 256) you can use this methods 

```swift
let decryptedPassword128 = aes128?.decrypt(data: encryptedPassword128)
let decryptedPassword256 = aes256?.decrypt(data: encryptedPassword256)
```
