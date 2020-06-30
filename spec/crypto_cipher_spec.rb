RSpec.describe CryptoCipher do
  it "has a version number" do
    expect(CryptoCipher::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  it "create instace of Crypto AES" do
    cipher = CryptoCipher::CryptoAES256.new('./example/config/public_key.pem','./example/config/private_key.pem','./example/config/private_cipher.key')
    
    plan_text    = "loremipsu"
    encryt_text  = cipher.encrypt(plan_text)
    decrypt_text = cipher.decrypt(encryt_text)

    expect(plan_text).to eq(decrypt_text)
  end

  it "create instace of Crypto Base64" do
    cipher = CryptoCipher::CryptoBS64.new 
    
    plan_text    = "loremipsu"
    encryt_text  = cipher.encode(plan_text)
    decrypt_text = cipher.decode(encryt_text)

    expect(plan_text).to eq(decrypt_text)
  end

end
