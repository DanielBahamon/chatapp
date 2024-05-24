class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username
end
