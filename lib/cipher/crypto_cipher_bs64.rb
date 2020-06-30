require "base64"

module CryptoCipher
    class CryptoBS64

        def encode(args)
            Base64.encode64(args)
        end

        def decode(args)
            Base64.decode64(args)
        end

    end
end
