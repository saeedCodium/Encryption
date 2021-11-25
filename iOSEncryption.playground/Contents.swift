import Foundation
import CommonCrypto

struct AES {

    private let key: Data
    private let iv: Data

    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }

    // MARK: Encrypt function
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    // MARK: Decrypt function
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else {return nil}
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

let password = "The Password"
let key128   = "8745231065432717"
let key256   = "82564903257897543401126783548762"
let iv       = "CODIUMCOMPANYLtd"

let aes128 = AES(key: key128, iv: iv)
let aes256 = AES(key: key256, iv: iv)

let encryptedPassword128 = aes128?.encrypt(string: password)
print(encryptedPassword128!.base64EncodedString())
let decryptedPassword128 = aes128?.decrypt(data: encryptedPassword128)
print(decryptedPassword128!)
let encryptedPassword256 = aes256?.encrypt(string: password)
print(encryptedPassword256!.base64EncodedString())
let decryptedPassword256 = aes256?.decrypt(data: encryptedPassword256)
print(decryptedPassword256!)
