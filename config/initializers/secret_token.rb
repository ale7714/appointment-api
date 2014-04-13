# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
AppointmentApi::Application.config.secret_key_base = 'ca236da7fa96c3a95f722abb23875b2a21650241534438d69a59368c7e71be38f08015e8401f6aa11d10763516359a374850f9c11bb04c0c8e0c7a4fc2060e54'
