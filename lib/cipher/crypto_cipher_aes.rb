require 'openssl'
require "base64"

module CryptoCipher
    class CryptoAES256

    attr_accessor :cipher
    attr_accessor :random_key
    attr_accessor :random_iv
    
    attr_accessor :private_cipher
    attr_accessor :public_key
    attr_accessor :private_key

    def initialize(public_key_file, private_key_file,  private_cipher_file = './config/private_cipher.key')
        
        @cipher = OpenSSL::Cipher.new('aes256')

        @private_cipher = private_cipher_file
           
        @public_key  = OpenSSL::PKey::RSA.new(File.read(public_key_file))
        @private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
        
        if exist_rsa_keys
            puts 'create values'
            @cipher.encrypt

            @random_key = @cipher.random_key
            @random_iv  = @cipher.random_iv

            create_key_iv @random_key, @random_iv 
        else 
            rsa = get_key_iv
            @random_key = rsa[:random_key]
            @random_iv  = rsa[:random_iv]
        end
    end 

    private 
        
        :cipher
        :random_key
        :random_iv

        :private_cipher
        :public_key
        :private_key

        def exist_rsa_keys
          !File.exist? @private_cipher
        end

        def get_key_iv
          begin
            line_num = 0
            rsa_keys = {random_key:  nil, random_iv: nil}
            text = File.open(@private_cipher).read
            text.each_line do |line|
              if line_num ==0
                  rsa_keys[:random_key] = Base64.decode64(line)
                  line_num += 1
              elsif line_num == 1
                  rsa_keys[:random_iv] = Base64.decode64(line)
                  line_num += 1
              end
            end
            return rsa_keys
          rescue
            return nil
          end
        end

        def create_key_iv(random_key, random_iv)
          begin
            if exist_rsa_keys
              rsa = File.new(@private_cipher,'w:UTF-8')
                  rsa.puts Base64.strict_encode64(random_key)
                  rsa.puts Base64.strict_encode64(random_iv)
              rsa.close
            end
            return true
          rescue
              return false
          end
        end

    public 

        def encrypt(plain_data)
            @cipher.encrypt
            
            @cipher.key = @random_key
            @cipher.iv  = @random_iv

            encrypted_data = @cipher.update(plain_data) + cipher.final
            return Base64.strict_encode64(encrypted_data)
        end


        def decrypt(encrypted_data)
            @cipher.decrypt

            encrypted_key = @public_key.public_encrypt(@random_key)
            encrypted_iv = @public_key.public_encrypt(@random_iv)

            @cipher.key = @private_key.private_decrypt(encrypted_key)
            @cipher.iv = @private_key.private_decrypt(encrypted_iv)

            decrypted_data = @cipher.update(Base64.decode64(encrypted_data)) + cipher.final
            return decrypted_data
        end 

    end
end
